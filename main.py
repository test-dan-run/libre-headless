import os
import shutil
import subprocess
from fastapi import FastAPI, File, UploadFile
from fastapi.responses import FileResponse

# create directory where the temporary pdf outputs will be stored
OUTPUT_DIR: str = "/pdf_out"
os.makedirs(OUTPUT_DIR)

app = FastAPI()

def pdf_convert(input_filename: str) -> str:
    """
    return: (str) output path of converted pdf file
    """

    cmd = f"libreoffice24.2 --headless --convert-to pdf {input_filename} --outdir {OUTPUT_DIR}"
    subprocess.run(cmd.split())

    input_ext = os.path.splitext(input_filename)[-1]
    output_filename = input_filename.replace(input_ext, ".pdf")
    output_filepath = os.path.join(OUTPUT_DIR, output_filename)

    return output_filepath

@app.post("/upload")
def upload(file: UploadFile = File(...)):

    # clear out previous converted files
    print(os.listdir(OUTPUT_DIR))
    shutil.rmtree(OUTPUT_DIR)

    try:
        contents = file.file.read()
        with open(file.filename, 'wb') as f:
            f.write(contents)

        output_filepath = pdf_convert(file.filename)

    except Exception as e:
        return {"message": f"There was an error uploading the file. Error: {e}"}
    finally:
        file.file.close()
        # clear out input files
        os.remove(file.filename)

    return FileResponse(output_filepath)
