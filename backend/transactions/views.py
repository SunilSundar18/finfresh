from rest_framework import generics, permissions, response
from .models import Transaction
from .serializers import TransactionSerializer
from .services import FinancialService

class TransactionListCreateView(generics.ListCreateAPIView):
    serializer_class = TransactionSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        queryset = Transaction.objects.filter(user=user)
        # Filters
        t_type = self.request.query_params.get('type')
        cat = self.request.query_params.get('category')
        if t_type: queryset = queryset.filter(type=t_type)
        if cat: queryset = queryset.filter(category=cat)
        return queryset.order_by('-date')

    def perform_create(self, serializer):
        # Server-side userId extraction (Never trust request body)
        serializer.save(user=self.request.user)

class SummaryView(generics.GenericAPIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        data = FinancialService.get_monthly_summary(request.user)
        return response.Response(data)

class FinancialHealthView(generics.GenericAPIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        data = FinancialService.calculate_health_score(request.user)
        return response.Response(data)