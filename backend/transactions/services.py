from django.db.models import Sum
from django.utils import timezone

from finfresh import settings
from .models import Transaction

class FinancialService:
    @staticmethod
    def get_monthly_summary(user):
        today = timezone.now().date() # Get the current date (Year-Month-Day)
        
        # Filter strictly by the Month and Year of the transaction date
        transactions = Transaction.objects.filter(
            user=user, 
            date__month=today.month, 
            date__year=today.year
        )
        
        income = transactions.filter(type='income').aggregate(Sum('amount'))['amount__sum'] or 0
        expense = transactions.filter(type='expense').aggregate(Sum('amount'))['amount__sum'] or 0
        
        income = float(income)
        expense = float(expense)
        savings = income - expense
        savings_rate = (savings / income * 100) if income > 0 else 0
        
        breakback = transactions.values('category').annotate(total=Sum('amount'))
        
        return {
            "income": income,
            "expense": expense,
            "savings": savings,
            "savingsRate": round(max(0, savings_rate), 2),
            "breakdown": list(breakback)
        }

    @staticmethod
    def calculate_health_score(user):
        today = timezone.now().date()
        
        # Use current month for ratios
        curr_month_tx = Transaction.objects.filter(
            user=user, 
            date__month=today.month, 
            date__year=today.year
        )
        
        income = float(curr_month_tx.filter(type='income').aggregate(Sum('amount'))['amount__sum'] or 0)
        
        if income <= 0:
            return {"score": 0, "label": "At Risk", "message": "No income found for the current month."}

        # 1. Emergency Fund (All time savings vs 3-month avg expense)
        total_income_all_time = float(Transaction.objects.filter(user=user, type='income').aggregate(Sum('amount'))['amount__sum'] or 0)
        # Simplified: Use current month expense as a proxy if 3-month data is low
        avg_expense = float(curr_month_tx.filter(type='expense').aggregate(Sum('amount'))['amount__sum'] or 0)
        
        if avg_expense <= 0:
            ef_score = 25
        else:
            ef_months = total_income_all_time / avg_expense
            ef_score = min(25, (ef_months / 6) * 25)

        # 2. Savings Rate (Goal 20%)
        curr_exp = float(curr_month_tx.filter(type='expense').aggregate(Sum('amount'))['amount__sum'] or 0)
        sr_score = min(25, (((income - curr_exp) / income) * 100 / 20) * 25) if income > curr_exp else 0

        # 3. Debt Ratio (Goal < 30%)
        debt = float(curr_month_tx.filter(type='debt').aggregate(Sum('amount'))['amount__sum'] or 0)
        dr_score = max(0, 25 - ((debt / income) * 100 / 30 * 25))

        # 4. Investment Ratio (Goal 15%)
        inv = float(curr_month_tx.filter(type='investment').aggregate(Sum('amount'))['amount__sum'] or 0)
        ir_score = min(25, ((inv / income) * 100 / 15) * 25)

        total = ef_score + sr_score + dr_score + ir_score
        
        labels = [(80, "Excellent"), (60, "Healthy"), (40, "Moderate"), (0, "At Risk")]
        label = next(l for s, l in labels if total >= s)


        suggestions = []
        if ef_score < 20:
            suggestions.append("Your emergency fund is low. Aim for 6 months of expenses in savings.")
        if sr_score < 15:
            suggestions.append("Try to increase your savings rate towards 20% by reducing non-essential expenses.")
        if dr_score < 15:
            suggestions.append("Your debt ratio is a bit high. Focus on paying down high-interest balances.")
        if ir_score < 15:
            suggestions.append("Consider increasing your investments to 15% of your income for long-term growth.")
        
        if not suggestions:
            suggestions.append("You're in great financial shape! Keep maintaining these habits.")

        health_data = {
            "user_id": user.id,
            "username": user.username,
            "score": round(total, 2),
            "label": label,
            "components": {
                "emergencyFund": round(ef_score, 2),
                "savingsRate": round(sr_score, 2),
                "debtRatio": round(dr_score, 2),
                "investmentRatio": round(ir_score, 2)
            },
            "created_at": timezone.now() # Mongo loves datetime objects
        }

        # --- THE BRIDGE: Push to MongoDB ---
        try:
            # We create a copy for Mongo because it modifies the dict by adding _id
            mongo_data = {
                "user_id": user.id,
                "username": user.username,
                "score": round(total, 2),
                "label": label,
                "components": {
                    "emergencyFund": round(ef_score, 2),
                    "savingsRate": round(sr_score, 2),
                    "debtRatio": round(dr_score, 2),
                    "investmentRatio": round(ir_score, 2)
                },
                "created_at": timezone.now() 
            }
            settings.MONGO_DB["finfreshcollection"].insert_one(mongo_data)
        except Exception as e:
            print(f"❌ MongoDB Save Error: {e}")

        # RETURN THIS for the Django Response (No Datetime objects here)
        return {
            "score": round(total, 2), 
            "label": label,
            "components": {
                "emergencyFund": round(ef_score, 2),
                "savingsRate": round(sr_score, 2),
                "debtRatio": round(dr_score, 2),
                "investmentRatio": round(ir_score, 2)
            },
            "suggestions": suggestions # Ensure Flutter gets this!
        }