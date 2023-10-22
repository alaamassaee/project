
# Backend Application README

## Overview

This is the backend application for the Review Application, a simple web service that allows users to add products and reviews. It provides RESTful APIs to manage products and their associated reviews. The application is built using Python and Flask, with a MySQL database to store product and review data.

## Features

- Add new products with their names.
- Add reviews for existing products, along with sentiment analysis for each review.
- Retrieve a list of all products and their reviews.

### AI Features

The backend application leverages AI-driven sentiment analysis using the TextBlob library to enhance the review system. When users submit reviews, the application automatically performs sentiment analysis on the review content, providing additional insights into each review's sentiment. The sentiment analysis generates two scores for each review:

- **Polarity**: A numeric value indicating the sentiment's polarity ranging from -1.0 (negative) to 1.0 (positive).
- **Subjectivity**: A numeric value indicating the review's subjectivity ranging from 0.0 (objective) to 1.0 (subjective).

These AI-generated scores enable users to gain a better understanding of the sentiment expressed in reviews, and they can also be used to visualize and analyze product sentiment over time.


## Prerequisites

- Python 3.6 or higher
- MySQL database (with appropriate credentials and schema) or use AWS SecretsManager for database credentials.

## Installation

1. Clone the repository:

```sh
git clone ssh_clone_url_for_the_repo
cd api-backend/
```

2. Install the required packages:

```sh
pip install -r requirements.txt
```

## Configuration

1. Database Credentials:

   The application retrieves database credentials from AWS SecretsManager. Secret name should match what the application expects(`db_credentials = get_secret('your_secret_name_here')` line the `app.py` file). Make sure to create a secret in AWS SecretsManager containing the required database credentials in the form of a dictionary, as shown below:

   ```json
   {
       "DB_USERNAME": "your_db_username",
       "DB_PASSWORD": "your_db_password",
       "DB_ENDPOINT": "your_db_endpoint",
       "DB_NAME": "your_db_name"
   }

2. Running the Application:

    To start the Flask server, run the following command:

    ```sh
    python app.py
    ```

    The application will be accessible at port 80 by default.

# API Endpoints

- **POST /product:** Add a new product.

    Request:

    ```bash
    curl -X POST -H "Content-Type: application/json" -d '{"product_name": "Product Name"}' http://localhost:80/product
    ```
    Response:

    ```json
    {
        "message": "Product added successfully",
        "product_id": 1
    }
    ```

- **POST /product/{product_id}/review:** Add a review for a product.

    Request:

    ```bash
    curl -X POST -H "Content-Type: application/json" -d '{"review": "Review content"}' http://localhost:80/product/{product_id}/review
    ```
    Response:

    ```json
    {
        "message": "Review added successfully",
        "review_id": 1,
        "polarity": 0.5,
        "subjectivity": 0.6
    }
    ```

    Replace {product_id} with the actual ID of the product you want to add the review for.


- **GET /product:** Get a list of all products.

    Request:

    ```bash
    curl -X GET http://localhost:80/product
    ```
    Response:

    ```json
    {
        "products": [
            {
                "id": 1,
                "name": "Product Name 1"
            },
            {
                "id": 2,
                "name": "Product Name 2"
            }
        ]
    }
    ```

- **GET /product/{product_id}/review:** Get reviews for a specific product.

    Request:

    ```bash
    curl -X GET http://localhost:80/product/{product_id}/review
    ```
    Response:

    ```json
    {
        "reviews": [
            {
                "id": 1,
                "content": "Review content 1",
                "rating": 8,
                "subjectivity": 0.6
            },
            {
                "id": 2,
                "content": "Review content 2",
                "rating": 7,
                "subjectivity": 0.7
            }
        ]
    }
    ```

# Health check Endpoints/HTTP path

- When configuring Health checks (ex: on an Application Load Balancer) to check if this backend application is healthy - you can use `/product` HTTP path above as it will return an HTTP 200 status code if the application is healthy and can display a list of available products in the database.

