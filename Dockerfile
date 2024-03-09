# Use a base image that contains both Bash and Terraform
#FROM hashicorp/terraform:latest
FROM zubairpathan/terraform_by_zubair:latest
# Set the working directory inside the container
WORKDIR /app

# Copy the bash script and Terraform files into the container
#COPY deploy.sh .
COPY openshift.tf /app/

# Make the bash script executable
#RUN chmod +x deploy.sh

# Execute the bash script when the container starts
#CMD ["./deploy.sh"]
COPY deploy.sh /app/deploy.sh
RUN chmod +x /app/deploy.sh
CMD ["/app/deploy.sh"]


