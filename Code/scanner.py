import cv2
from pyzbar.pyzbar import decode


barcode_values = []

def decode_barcode(frame):
    global barcode_values
   
   
    gray_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    
   
    barcodes = decode(gray_frame)
    for barcode in barcodes:
        x, y, w, h = barcode.rect
        
        
        cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)
        
       
        barcode_data = barcode.data.decode('utf-8')
        text = f'{barcode_data}'
        cv2.putText(frame, text, (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)

        
        if barcode_data not in barcode_values:
            barcode_values.append(barcode_data)
            print(f"Detected barcode: {barcode_data}")
            
           
            with open("barcodes.txt", "a") as file:
                file.write(f"{barcode_data}\n")

    return frame

def main():
  
    cap = cv2.VideoCapture(0)

    if not cap.isOpened():
        print("Error: Could not open webcam.")
        return

    while True:
       
        ret, frame = cap.read()

        if not ret:
            print("Error: Failed to capture image.")
            break

        
        frame = decode_barcode(frame)

        
        cv2.imshow('Barcode Scanner', frame)

       
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    
    cap.release()
    cv2.destroyAllWindows()

   
    print("Detected barcodes:")
    for value in barcode_values:
        print(value)

if __name__ == "__main__":
    main()
