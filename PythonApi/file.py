import base64
import os
import random
from urllib import response
import cv2
from flask import Flask, request, jsonify, send_file
from flask_cors import CORS
import numpy as np
from PIL import Image
from werkzeug.utils import secure_filename
from io import BytesIO
from pytesseract import pytesseract
import os
import io
from google.cloud import vision_v1 as vision
from google.cloud.vision_v1 import types
import re


app = Flask(__name__)
CORS(app)


@app.route('/upload', methods=['POST'])
def upload():
    file = request.files['image']
    image = file.read()
    encoded_image = base64.b64encode(image).decode('utf-8')
    
    # Save the received image to disk
    save_path = os.path.join(app.root_path, 'images', 'received_image.png')
    with open(save_path, 'wb') as f:
        f.write(image)

    # Load the cascade classifier for plate detection
    cascade = cv2.CascadeClassifier('resources\haarcascade_russian_plate_number.xml')

    # Read the image and convert it to grayscale
    image = cv2.imread('images/received_image.png')
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    try:
        # Detect the plates in the image
        plates = cascade.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=5, minSize=(30, 30))

        # Extract the plate image and draw a rectangle around it
        for (x, y, w, h) in plates:
            plate_img = image[y:y+h, x:x+w]
            cv2.rectangle(image, (x, y), (x + w, y + h), (0, 255, 0), 2)

        # Display the plate image
        # cv2.imshow('Number plate', plate_img)
        
        # Set the path to the service account key file
        os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = 'resources/textextractioncloud-06dd9ab2dffe.json'

        # Instantiate a client
        client = vision.ImageAnnotatorClient()

        # Load the plate image into memory
        success, encoded_plate = cv2.imencode('.jpg', plate_img)
        content = encoded_plate.tobytes()
        image = types.Image(content=content)

        # Configure the OCR parameters
        config = types.ImageContext(
            language_hints=['en'],
        )

        response = client.text_detection(image=image, image_context=config)
        texts = response.text_annotations

        try:
            # Extract the detected text and check if "applied" exists in it
            detected_text = texts[0].description.lower()
            if "applied" in detected_text:
                # If "applied" exists, assign a random value and park the car
                plate_number = random.randint(10000, 99999)
                print(f"Plate number {plate_number} assigned to car")
                park_car(plate_number)
            else:
                # If "applied" doesn't exist, use the extracted text for parking
                print(f"Detected plate number: {detected_text}")
                park_car(detected_text)
        except:
            print('Number plate not detected')

        # Wait for a key press to close the window
        cv2.waitKey(0)

    except:
        print("hi")
            # Set the path to the service account key file
        os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = 'resources/textextractioncloud-06dd9ab2dffe.json'

        # Instantiate a client
        client = vision.ImageAnnotatorClient()

        # Set the path to the image file
        file_name = 'images/received_image.png'

        # Load the image into memory
        with io.open(file_name, 'rb') as image_file:
            content = image_file.read()
        image = types.Image(content=content)

        # Configure the OCR parameters
        config = types.ImageContext(
            language_hints=['en'],
        )

        response = client.text_detection(image=image, image_context=config)
        texts = response.text_annotations

        try:
            # Extract the detected text and check if "applied" exists in it
            detected_text = texts[0].description.lower()
            if "applied" in detected_text:
                # If "applied" exists, assign a random value and park the car
                plate_number = random.randint(10000, 99999)
                print(f"Plate number {str(plate_number)} assigned to car")
                park_car(str(plate_number))
            else:
                # If "applied" doesn't exist, use the extracted text for parking
                print(f"Detected plate number: {detected_text}")
                park_car(detected_text)
        except:
            print('Number plate not detected')
    cv2.destroyAllWindows()
        
    
    return {'image': encoded_image}




# car out
@app.route('/CarOut', methods=['POST'])
def CarOut():
    file = request.files['image']
    image = file.read()
    encoded_image = base64.b64encode(image).decode('utf-8')
    
    # Save the received image to disk
    save_path = os.path.join(app.root_path, 'images', 'received_image.png')
    with open(save_path, 'wb') as f:
        f.write(image)



    # Load the cascade classifier for plate detection
    cascade = cv2.CascadeClassifier('resources\haarcascade_russian_plate_number.xml')

    # Read the image and convert it to grayscale
    image = cv2.imread('images/received_image.png')
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    try:
        # Detect the plates in the image
        plates = cascade.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=5, minSize=(30, 30))

        # Extract the plate image and draw a rectangle around it
        for (x, y, w, h) in plates:
            plate_img = image[y:y+h, x:x+w]
            cv2.rectangle(image, (x, y), (x + w, y + h), (0, 255, 0), 2)

        # Display the plate image
        # cv2.imshow('Number plate', plate_img)
        
        # Set the path to the service account key file
        os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = 'resources/textextractioncloud-06dd9ab2dffe.json'

        # Instantiate a client
        client = vision.ImageAnnotatorClient()

        # Load the plate image into memory
        success, encoded_plate = cv2.imencode('.jpg', plate_img)
        content = encoded_plate.tobytes()
        image = types.Image(content=content)

        # Configure the OCR parameters
        config = types.ImageContext(
            language_hints=['en'],
        )

        # Use the Cloud Vision API to detect text in the image
        response = client.text_detection(image=image, image_context=config)
        texts = response.text_annotations

        # Print the detected text
        print(texts[0].description)
        delete_cars(texts[0].description)
        # park_car(texts[0].description)

        # Wait for a key press to close the window
        cv2.waitKey(0)

    except:
        print("hi")
            # Set the path to the service account key file
        os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = 'resources/textextractioncloud-06dd9ab2dffe.json'

        # Instantiate a client
        client = vision.ImageAnnotatorClient()

        # Set the path to the image file
        file_name = 'images/received_image.png'

        # Load the image into memory
        with io.open(file_name, 'rb') as image_file:
            content = image_file.read()
        image = types.Image(content=content)

        # Configure the OCR parameters
        config = types.ImageContext(
            language_hints=['en'],
        )

        # Use the Cloud Vision API to detect text in the image
        response = client.text_detection(image=image, image_context=config)
        texts = response.text_annotations

        print(texts[0].description)
        delete_cars(texts[0].description)
        # park_car(lines[0])
        # # Print the filtered lines
        # for line in lines:
        #  print(line)
    cv2.destroyAllWindows()
    
    return {'image': encoded_image}




rows = []  # Initialize an empty list to store the rows
row_capacity = 5  # Number of cars that can be parked in each row
num_rows = 3  # Number of rows in the parking lot

# Initialize the parking lot with empty spaces
for i in range(num_rows):
    rows.append([""] * row_capacity)

def park_car(license_plate):
    """
    Parks a car in the first available spot in the parking lot.
    """
    for i in range(num_rows):
        for j in range(row_capacity):
            if rows[i][j] == "":
                rows[i][j] = license_plate
                print(f"{license_plate} has been parked in row {i+1}, spot {j+1}.")
                return  # Exit the function once the car has been parked

    # If no spots are available, print an error message
    print("Sorry, the parking lot is full.")

def search1(num_to_search):
    """
    Searches for the given number in the parking lot and returns the location of the car if found.
    """
    for i in range(num_rows):         # Loop over each row in the parking lot
        for j in range(row_capacity): # Loop over each spot in the row
            if num_to_search in rows[i][j] : # Check if the current spot contains the number we're searching for
                # If a match is found, print a message indicating the location of the car and return it as a string
                print('Car Found')
                return 'Car Parked in row '+str(i+1)+', at spot ' +str(j+1) 
    # If we reach this point, the car was not found, so print a message and return it as a string
    print('No car found at this number')
    return 'No car found at this number'

def search2(num_to_search):
    """
    Searches for the given number in the parking lot and returns the location of the car if found.
    """
    for i in range(num_rows):         # Loop over each row in the parking lot
        for j in range(row_capacity): # Loop over each spot in the row
            if num_to_search in rows[i][j] : # Check if the current spot contains the number we're searching for
                # If a match is found, print a message indicating the location of the car and return it as a string
                delete_cars(num_to_search)
                print('Car Checked Out Succesfully')
                return 'Car Checked Out Succesfully from row '+str(i+1)+', at spot ' +str(j+1) 
    # If we reach this point, the car was not found, so print a message and return it as a string
    print('No car found at this number')
    return 'No car found at this number'

def delete_cars(text):
    # Loop through each row in the parking lot
    for i in range(len(rows)):
        row = rows[i]
        # Loop through each parking spot in the row
        for j in range(len(row)):
            # Check if the current parking spot matches the provided text
            if text in row[j]:
                # If it matches, delete the car from the parking spot
                rows[i][j] = ""
                return True  # Return True to indicate that the car has been deleted
    # If the car was not found in the parking lot, return False
    return False



park_car("ABC123")
park_car("ABC 12334")            
            

@app.route('/search', methods=['GET'])
def search():
    search_query = request.args.get('query')
    found=search1(search_query)
    
    result = {'message': found}
    return found  
    # if(found == True):
    #     # Perform some search operation using search_query
    #     result = {'message': f'Car Found'}
    #     return jsonify(result)
    # else:
    #     result = {'message': f'No Car found for this number please scan again'}
    #     return jsonify(result)
    
@app.route('/searchDelete', methods=['GET'])
def searchDelete():
    search_query = request.args.get('query')
    found=search2(search_query)
    
    result = {'message': found}
    return found      



if __name__ == '__main__':
    app.run(debug=True)
    