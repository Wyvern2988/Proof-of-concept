# Use official Node.js image as base
FROM node:16

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json first (to leverage Docker cache for better performance)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files to the container
COPY . .

# Expose the port the app will run on
EXPOSE 3000

# Command to run the application
CMD ["node", "app.js"]
