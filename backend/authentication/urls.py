from django.urls import path
from .views import RegisterView
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)

urlpatterns = [
    # POST /auth/register
    path('register/', RegisterView.as_view(), name='auth_register'),
    
    # POST /auth/login (Returns JWT and User Info)
    path('login/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    
    # Optional: Endpoint to refresh the access token using the refresh token
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
]