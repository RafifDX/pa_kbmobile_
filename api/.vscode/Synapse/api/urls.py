from django.contrib import admin
from django.urls import path
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from api.views import predict_image

# Test view langsung di sini
@csrf_exempt
def test_view(request):
    return JsonResponse({'status': 'OK', 'message': 'URL routing works!'})

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/test/', test_view),  # Test endpoint
    path('predict-image/', predict_image, name="predict-image"),

]

print("\n🔍 URLs loaded:")
for p in urlpatterns:
    print(f"  - {p.pattern}")