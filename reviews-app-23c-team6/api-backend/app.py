import os
import boto3
from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from textblob import TextBlob

app = Flask(__name__)
CORS(app)

# Retrieve database credentials from AWS SecretsManager
def get_secret(secret_name, region_name="us-east-1"):
    client = boto3.client('secretsmanager', region_name=region_name)
    response = client.get_secret_value(SecretId=secret_name)
    secret_data = response['SecretString']
    return eval(secret_data)  # Assuming the secret data is stored as a dictionary

# Database credentials retrieved from AWS SecretsManager
db_credentials = get_secret('your_secret_name_here')
app.config['SQLALCHEMY_DATABASE_URI'] = f"mysql+pymysql://{db_credentials['DB_USERNAME']}:{db_credentials['DB_PASSWORD']}@{db_credentials['DB_ENDPOINT']}/{db_credentials['DB_NAME']}"
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class Product(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), unique=True, nullable=False)
    reviews = db.relationship('Review', backref='product', lazy=True)

class Review(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    content = db.Column(db.String(200), nullable=False)
    product_id = db.Column(db.Integer, db.ForeignKey('product.id'), nullable=False)
    polarity = db.Column(db.Float)    # added field for sentiment polarity
    subjectivity = db.Column(db.Float)  # added field for sentiment subjectivity

@app.route('/product', methods=['POST'])
def add_product():
    product_name = request.json.get('product_name')
    product = Product(name=product_name)
    db.session.add(product)
    db.session.commit()
    return jsonify({'message': 'Product added successfully', 'product_id': product.id})

@app.route('/product/<int:product_id>/review', methods=['POST'])
def add_review(product_id):
    review_content = request.json.get('review')

    # Add sentiment analysis
    sentiment = TextBlob(review_content).sentiment
    polarity = sentiment.polarity
    subjectivity = sentiment.subjectivity

    review = Review(content=review_content, product_id=product_id, polarity=polarity, subjectivity=subjectivity)
    db.session.add(review)
    db.session.commit()
    return jsonify({'message': 'Review added successfully', 'review_id': review.id, 'polarity': polarity, 'subjectivity': subjectivity})

@app.route('/product', methods=['GET'])
def get_products():
    products = Product.query.all()
    return jsonify({'products': [{'id': product.id, 'name': product.name} for product in products]})

@app.route('/product/<int:product_id>/review', methods=['GET'])
def get_reviews(product_id):
    reviews = Review.query.filter_by(product_id=product_id).all()
    def convert_to_star_rating(polarity):
        # Map polarity score to a scale of 1 to 10
        star_rating = round(((polarity + 1.0) / 2.0) * 10)
        return star_rating
    return jsonify({'reviews': [
        {
            'id': review.id,
            'content': review.content,
            'rating': convert_to_star_rating(review.polarity),
            'subjectivity': review.subjectivity
        } for review in reviews
    ]})

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=80)
