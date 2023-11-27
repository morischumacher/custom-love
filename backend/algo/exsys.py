from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, classification_report
import numpy as np
import joblib
from io import BytesIO
from backend.models.expert_system import ExpertSystem
from backend.routers.user import fetch_expert_system


class ExSys:
    def __init__(self, users, training_data):
        self.users = users
        self.training_data = training_data
        self.model = None

    def train_model(self, target_user_id):
        X, y = self.prepare_data(target_user_id)
        X_train, X_test, y_train, y_test = train_test_split(X, y, train_size=0.8, random_state=42)

        # Train logistic regression model
        model = LogisticRegression()
        model.fit(X_train, y_train)

        # Evaluate the model
        y_pred = model.predict(X_test)
        print("Accuracy:", accuracy_score(y_test, y_pred))
        print("Classification Report:\n", classification_report(y_test, y_pred))

        self.model = model

    def prepare_data(self, target_user_id):
        # Create feature matrix (X) and target vector (y) from training_data for the specified target_user
        X = []
        y = []

        # Extract likes and dislikes for the target_user
        likes = self.training_data.get(target_user_id, {})

        for liked_user, like_probability in likes.items():
            # Extract relevant features from users and construct feature vector
            user_features = self.extract_features(self.users[target_user_id], self.users[liked_user])
            X.append(user_features)

            # Binary label: 1 if liked, 0 if disliked
            y.append(like_probability)

        return np.array(X), np.array(y)

    def extract_features(self, user, liked_user):
        # Extract relevant features from users and construct feature vector
        # This is a simplified example; you may need to customize this based on your user model
        user_features = [
            user["biolenght"],
            user["age"],
            user["genderid"]
            # Add more features as needed
        ]

        liked_user_features = [
            liked_user["biolenght"],
            liked_user["age"],
            liked_user["genderid"]
            # Add more features as needed
        ]

        return user_features + liked_user_features

    def predict_probability(self, target_user_id, liked_user):
        # Predict the probability of the target_user liking the liked_user
        features = self.extract_features(self.users[target_user_id], self.users[liked_user])
        probability = self.model.predict_proba([features])[:, 1]  # Probability of class "1" (like)
        return probability

    def order_users_by_probability(self, target_user_id):
        # Order other users by the predicted probability of target_user liking them
        if self.model is None:
            raise ValueError("Model not trained. Please train the model first.")

        probabilities = []
        for other_user in self.users:
            if other_user != target_user_id:
                probability = self.predict_probability(target_user_id, other_user)
                probabilities.append((other_user, probability))

        # Sort users by probability in descending order
        sorted_users = sorted(probabilities, key=lambda x: x[1], reverse=True)
        return sorted_users

    def update_model(self, user_id):

        # Assuming 'self.model' is your scikit-learn model
        serialized_model = BytesIO()
        joblib.dump(self.model, serialized_model)
        model_data = serialized_model.getvalue()
        return fetch_expert_system(user_id, model_data)


# Initial Training Data
user1 = {"id": 1, "biolenght": 25, "age": 10, "genderid": 1}
user2 = {"id": 2, "biolenght": 30, "age": 15, "genderid": 2}
user3 = {"id": 3, "biolenght": 28, "age": 12, "genderid": 2}
user4 = {"id": 4, "biolenght": 32, "age": 18, "genderid": 1}
user5 = {"id": 5, "biolenght": 22, "age": 8, "genderid": 2}
user6 = {"id": 6, "biolenght": 35, "age": 20, "genderid": 1}
user7 = {"id": 7, "biolenght": 29, "age": 14, "genderid": 2}
user8 = {"id": 8, "biolenght": 27, "age": 16, "genderid": 1}

# Example Training Data
# Updated Training Data
training_data = {
    user1["id"]: {user2["id"]: 1, user3["id"]: 0, user4["id"]: 1, user5["id"]: 0, user6["id"]: 1, user7["id"]: 0, user8["id"]: 1}
}


# Initialize and use the expert system for user1
users = {user["id"]: user for user in [user1, user2, user3, user4, user5, user6, user7, user8]}
exsys = ExSys(users, training_data)


target_user = user1["id"]
exsys.train_model(target_user)

# Now you can order users based on predicted probabilities for user1
ordered_users = exsys.order_users_by_probability(target_user)

# Print the ordered users based on predicted probabilities
for user, probability in ordered_users:
    print(f"User ID: {user}, Probability: {probability}")

# Store model in database
exsys.update_model(1)
