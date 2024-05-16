import PyPDF2
import re

def extract_text_from_pdf(pdf_file: str) -> [str]:
    with open(pdf_file, 'rb') as pdf:
        reader = PyPDF2.PdfReader(pdf, strict=False)
        pdf_text = []

        for page in reader.pages:
            content = page.extract_text()
            pdf_text.append(content)

        return pdf_text

if __name__ == "__main__":
    extracted_text = extract_text_from_pdf("invoice.pdf")
    for text in extracted_text:
        print(text)

epwnimia = "ΕΠΩΝΥΜΙΑ"
pattern = r'{}: *[Α-Ω]+ [Α-Ω]+'.format(re.escape(epwnimia))
match = re.search(pattern, text)
epwnimia_value = match.group(1)

dieythinsi = "ΟΔΟΣ/ΑΡΙΘΜΟΣ"
pattern = r'{}: *[Α-Ω]+ [0-9]+'.format(re.escape(dieythinsi))
match = re.search(pattern, text)
dieythinsi_value = match.group(1)

thlefono = "ΤΗΛΕΦΩΝΟ"
pattern = r'{}: *[0-9]+'.format(re.escape(thlefono))
match = re.search(pattern, text)
thlefono_value = match.group(1)

afm = "ΑΦΜ/ΔΟΗ"
pattern = r'{}: *[0-9]+'.format(re.escape(afm))
match = re.search(pattern, text)
afm_value = match.group(1)

teliko_synolo = "ΤΕΛΙΚΟ ΣΥΝΟΛΟ"
pattern = r'{}: *[0-9]+.[0-9]+'.format(re.escape(teliko_synolo))
match = re.search(pattern, text)
teliko_synolo_value = match.group(1)

print(epwnimia_value)

