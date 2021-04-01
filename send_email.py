import email, smtplib, ssl,sys,os,pyminizip
from email import encoders
from email.mime.base import MIMEBase
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText


display_name = sys.argv[1]
user_email = sys.argv[2]
azure_username = sys.argv[3]
azure_password = sys.argv[4]
virtual_machine_username = sys.argv[5]
virtual_machine_password = sys.argv[6]
public_ip_address = sys.argv[7]

mobile_number = sys.argv[8]



sender_email = "nikhilpatne94@gmail.com"
password = "9766189990"
receiver_email = user_email


subject = display_name + " ,Welcome to your Microsoft Azure Account"

message = MIMEMultipart()
message["From"] = sender_email
message["To"] = receiver_email
message["Subject"] = subject
message["Bcc"] = sender_email


# message.attach(MIMEText(body, "plain"))

# write the HTML part
html = """\
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>xxx</title>
    <style>
    *{
    margin: 0;
    padding: 0;
    box-sizing: border-box;
  
}



.box {

    width: 60vw;
    height: auto;
    border: 1px solid rgb(209, 206, 206);
    margin: 20px auto;
    

}

.box_header {
    background-color: rgb(231, 228, 228);
    width: 100%;
    padding: 0px 50px;
    border-bottom: 1px solid rgba(63, 47, 47);
   
}

.box_header img {
    height: 10%;
    width: 25%;
    
}



.box_body {
    height: auto;
    padding: 30px 40px;
    width:100%;
    background-color: rgb(255, 255, 255);
    text-align: center;
    font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}


button {
    padding: 15px 5px;
    background-color: #0078d4;
    color: #fff;
    font-size: 20px;
    width:40%;
    border-radius: 10px;
    border: none;
    outline: none;
    cursor: pointer;
}



.box_footer {
    padding: 20px;
    width:100%;
    background-color: rgb(63, 68, 68);
    text-align: center;
    color: #fff;
}


a {
    color: #fff;
    text-decoration: none;
}
    </style>
</head>

<body>

        <div class="box">
                <div class="box_header">
                    <img src="https://access.on.ca/wp-content/uploads/2020/02/Microsoft-Azure-logo1.png"/>
                </div>

                <div class="box_body">
                   <h2>Hello Tanya</h2>
                    <br>
                    <p>Welcome to Microsoft Azure Account. Your new account has successfully created with access to Azure apps, and services.
                        </p>
                        <br><br>
                        <button><a href="https://portal.azure.com/#home" target="_blank" style="color:white">Go to Azure Portal</a></button>

                        <br><br>
                        <p>Kindly find below attachment for your initial credentials for login to azure account</p>
                        <br>
                        <p><b>Note:</b>This is password protected file. Use your <b>registered mobile number</b> as a password to open this file</p>

                        <br><br><br>
                        <p style="color:red; font-size: 13px">Contact your administrator for any queries</p>
                </div>

                <div class="box_footer">
                <p> &copy Copyright 2021 Great Software Laboratory. All rights reserved.</p>
                </div>
        </div>
</body>
</html>
"""
# convert both parts to MIMEText objects and add them to the MIMEMultipart message
part1 = MIMEText(html, "html")
message.attach(part1)


#   To create a Text file of credentials
filename = "azure_credentials.txt" 
fileObject = open(filename, "w")
fileObject.write("\n\n")
fileObject.write("Hey, {} Your account details are as follows...!! \n \n".format(display_name))
fileObject.write("============================================================================= \n \n")
fileObject.write("Your Initial Credentials of Azure portal : \n")
fileObject.write("             Username : {} \n".format(azure_username))
fileObject.write("             Password : {} \n \n".format(azure_password))
fileObject.write("------------------------------------------------------------------------------ \n \n")
fileObject.write("Your Virtual Machines Details : \n")
fileObject.write("             Username : {} \n".format(virtual_machine_username))
fileObject.write("             Password : {} \n".format(virtual_machine_password))
fileObject.write("             VMS_IP : {} \n \n".format(public_ip_address))
fileObject.write("================================================================================ \n \n")
fileObject.close()

pre = None
# output zip file path
output = "credentials.zip"

# set password value
file_password = mobile_number
# compress level
com_lvl = 5
# compressing file
pyminizip.compress(filename, None, output,
				file_password, com_lvl)

# Open PDF file in binary mode
with open(output, "rb") as attachment:
    # Add file as application/octet-stream
    # Email client can usually download this automatically as attachment
    part2 = MIMEBase("application", "octet-stream")
    part2.set_payload(attachment.read())

# Encode file in ASCII characters to send by email    
encoders.encode_base64(part2)

# Add header as key/value pair to attachment part
part2.add_header(
    "Content-Disposition",
    f"attachment; filename= {output}",
)

# Add attachment to message and convert message to string
message.attach(part2)
email_body = message.as_string()

# Log in to server using secure context and send email
context = ssl.create_default_context()
try:
    with smtplib.SMTP_SSL("smtp.gmail.com", 465, context=context) as server:
        server.login(sender_email, password)
        server.sendmail(sender_email, receiver_email, email_body)
    print("email sent")
except Exception as e:
    print("error occured while sending email",e)


# Delete the file 
os.remove(filename)
os.remove(output)