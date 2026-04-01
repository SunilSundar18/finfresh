from django.urls import path
from .views import TransactionListCreateView, SummaryView, FinancialHealthView

urlpatterns = [
    path('transactions/', TransactionListCreateView.as_view(), name='transaction-list'),
    path('summary/', SummaryView.as_view(), name='summary'),
    path('financial-health/', FinancialHealthView.as_view(), name='health-score'),
]