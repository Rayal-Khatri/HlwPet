from django.shortcuts import render
import torch
from torchvision import transforms
from torch import nn
from torchvision.utils import make_grid
from PIL import Image as PILImage
from io import BytesIO
import base64
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
# device = 'cuda' if torch.cuda.is_available() else 'cpu'
# device

model = torch.load("./media/fmodel.pth",map_location=torch.device('cpu'))

# Load the class names
info = torch.load('./media/finfo.pth',map_location=torch.device('cpu'))
classes=info['classes']
transformer = info['transform']

# Define transformations for input images
img_path= "./breed.png"

@csrf_exempt
def breed_detection(request):
    print("Received API request")
    uploaded_image = None
    encoded_image = None
    prediction_result = None

    if request.method == 'POST' and request.FILES.get('image'):
        uploaded_file = request.FILES['image']
        uploaded_image = PILImage.open(uploaded_file)

        image = transformer(uploaded_image).reshape(1, 3, 224, 224).to('cpu')

        with torch.no_grad():
            pred = model(image)
            probabilities = nn.functional.softmax(pred, dim=1)
            index = torch.argmax(probabilities, dim=1)
            max_probability = probabilities[0, index].item() * 100
            if max_probability < 60:
                prediction_result = {
                    'breed': "Breed not found in database, cannot identify",
                    'accuracy': ''
                }
            else:
                prediction_result = {
                    'breed': classes[index],
                    'accuracy': max_probability
                }
        
        # Encode image to Base64 for HTML display
        buffered = BytesIO()
        uploaded_image.save(buffered, format="PNG")
        encoded_image = base64.b64encode(buffered.getvalue()).decode("utf-8")

    context = {
        'uploaded_image': uploaded_image,
        'encoded_image': f"data:image/png;base64,{encoded_image}" if encoded_image else None,
        'prediction_result': prediction_result,
    }

    return render(request, 'breed_detection.html', context)

@csrf_exempt
def breed_detection_api(request):
    print("Received API request")
    if request.method == 'POST':
        print("im here")
        uploaded_file = request.FILES['image']
        uploaded_image = PILImage.open(uploaded_file)

        image = transformer(uploaded_image).reshape(1, 3, 224, 224).to('cpu')

        with torch.no_grad():
            pred = model(image)
            probabilities = nn.functional.softmax(pred, dim=1)
            index = torch.argmax(probabilities, dim=1)
            max_probability = probabilities[0, index].item() * 100
            if max_probability < 60:
                prediction_result = {
                    'breed': "Cannot Identify",
                    'accuracy': ''
                }
            else:
                breed_name=classes[index].capitalize()
                accuracy=f"{round(max_probability,2)}"
                prediction_result = {
                    'breed': breed_name,
                    'accuracy': accuracy,
                }
            print(prediction_result)
        return JsonResponse({'prediction_result': prediction_result})
    else:
        return JsonResponse({'error': 'Invalid request method or no image provided'})

def hello_world(request):
    if request.method=='POST':
        return JsonResponse({'message':'Hello World'})
