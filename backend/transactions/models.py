from django.db import models
from django.conf import settings

class Transaction(models.Model):
    TYPES = (
        ('income', 'Income'),
        ('expense', 'Expense'),
        ('investment', 'Investment'),
        ('debt', 'Debt'),
    )

    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    type = models.CharField(max_length=15, choices=TYPES)
    category = models.CharField(max_length=100)
    amount = models.DecimalField(max_digits=12, decimal_places=2)
    date = models.DateField()
    description = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        indexes = [models.Index(fields=['user', 'date', 'type'])]