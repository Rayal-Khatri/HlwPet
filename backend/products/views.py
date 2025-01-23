from django.shortcuts import render
from .models import Products
from .serializers import ProductSerializer
from rest_framework.decorators import api_view
from rest_framework.response import Response
from io import TextIOWrapper
import csv
from .forms import UploadFileForm

# Create your views here.
def display_products(request):
    if request.method == 'GET':
        products = Products.objects.all().order_by('-created_at')[:5]
        serializer = ProductSerializer(products)
        print(serializer.data)
        return Response(serializer.data)


# @api_view(['POST'])
# def upload_csv(request):
#     csv_file = TextIOWrapper(request.data['file'].file, encoding='utf-8')
#     reader = csv.DictReader(csv_file)

#     for row in reader:
#         Products.objects.create(
#             name=row['name'],
#             brand=row['brand'],
#             description=row['description'],
#             product_id=row['product_id'],
#             availability=bool(row['availability']),
#             price=float(row['price']),
#             avg_rating=float(row['avg_rating'])
#         )

#     return Response({'message': 'Data uploaded successfully'})

def upload_csv(request):
    if request.method == 'POST':
        form = UploadFileForm(request.POST, request.FILES)
        if form.is_valid():
            csv_file = TextIOWrapper(request.FILES['file'].file, encoding='utf-8')
            reader = csv.DictReader(csv_file)

            for row in reader:
                Products.objects.create(
                    name=row.get('name', ''),
                    brand=row.get('brand', ''),
                    description=row.get('description', ''),
                    product_id=row.get('product_id', ''),
                    availability=bool(row.get('availability', False)),
                    price=float(row['price (NRs)']) if row['price (NRs)'] else 0.0,
                    avg_rating=float(row['avg_rating']) if row['avg_rating'] else 0.0
)
            return render(request, 'success.html')
    else:
        form = UploadFileForm()

    return render(request, 'upload_csv.html', {'form': form})
