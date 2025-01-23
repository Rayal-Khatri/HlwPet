from django.db import models

# Create your models here.
class Products(models.Model):
    name = models.CharField(max_length=255)
    brand = models.CharField(max_length=255)
    description = models.TextField()
    product_id = models.CharField(primary_key=True,  max_length=50, unique=True)
    availability = models.BooleanField(default=True)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    avg_rating = models.FloatField()

    def __str__(self):
        return self.name
