from rest_framework import serializers
from .models import Transaction

class TransactionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Transaction
        fields = ['id', 'type', 'category', 'amount', 'date', 'description', 'created_at']
        
    def validate_amount(self, value):
        if value <= 0:
            raise serializers.ValidationError("Amount must be a positive number.")
        return value
class HealthComponentSerializer(serializers.Serializer):
    emergencyFund = serializers.FloatField()
    savingsRate = serializers.FloatField()
    debtRatio = serializers.FloatField()
    investmentRatio = serializers.FloatField()

class FinancialHealthSerializer(serializers.Serializer):
    score = serializers.FloatField()
    label = serializers.CharField()
    # Adding these two allows them to show up in Postman
    components = HealthComponentSerializer()
    suggestions = serializers.ListField(child=serializers.CharField())