from sklearn.linear_model import LogisticRegression
from datetime import date
import joblib
from io import BytesIO
from typing import List
from backend.models.user import User


class ExSys:
    """
    X_train: The features on which we train our model (in our case: all user features despite like/dislike)
    y_train: The target feature on which we train our model (in our case: like/dislike)
    X_predict: The features on which we want to make a decision (in our case: all user features despite like/dislike)
    y_predict: The decision (in our case: like/dislike)
    """
    def __init__(self, model):
        self.model = model

    # TODO
    def train_model(self, user_list: List[User], like_decisions: List[bool]):
        """
        Retrieves trainingsdata to train a model based on this. length(user_list)==length(like_decisions)
        param: user_list, list of user to train the model
        param: like_decisions, array of boolean which predict if the user liked(=1) or disliked(=0) the at the
        corresponding index
         return a model trained on the trainingsdata.
        """

        # Creates a logic regression model
        model = LogisticRegression()

        # Build input for model
        X_train, y_train = users_and_likes_to_x_train_y_train(user_list, like_decisions)

        # Train model
        model.fit(X_train, y_train)

        # set the model of the exsys instance
        self.model = model

        return model

    # TODO
    def update_model(self, user_list: List[User], like_decisions: List[bool]):
        """
        Retrieves a model and trainingsdata to update the model with the data. length(user_list)==length(like_decisions)
        param: model, existing logic regression model
        param: user_list, list of user to train the model
        param: like_decisions, array of boolean which predict if the user liked(=1) or disliked(=0) the at the
        corresponding index
         return the model updated with the trainingsdata.
        """

        # Build input for model
        X_train, y_train = users_and_likes_to_x_train_y_train(user_list, like_decisions)

        # Update existing model
        self.model.fit(X_train, y_train)

        return self.model

    def serialize_model(self):
        """
        Retrieves a LogicRegression model
        return a serialized object of the model to store in the database
        """
        # Create byte object
        bytes_object = BytesIO()
        # Dump model in byte object
        joblib.dump(self.model, bytes_object)
        # Get value of dump
        serialized_model = bytes_object.getvalue()

        return serialized_model

    def deserialize_and_set_model(self, serialized_model):
        """
        Retrieves a  serialized LogicRegression() model
        returns a LogicRegression() model read to use
        """

        # deserialize bytes object
        loaded_model = joblib.load(BytesIO(serialized_model))

        # set the model of the exsys instance
        self.model = loaded_model

        return self.model

    def predict(self, user_list: List[User]):
        """
        Retrieves a list of users
        returns a list with the probabilities for a like of the user.
        y_predict[0]==0.8 ->  user at position user_list[0] will be liked with a probability of 80%
        """
        # Create list with predictions
        y_predict = []

        for user in user_list:
            X_test = users_to_x_predict(user)
            probability = self.model.predict_proba(X_test)[0, 1]  # Probability of class "1" (liked)
            y_predict.append(probability)

        return y_predict


def users_and_likes_to_x_train_y_train(user_list: List[User], like_decisions: List[bool]):
    # Mapping dictionary for encoding gender labels
    gender_mapping = {"men": 1, "woman": 2, "divers": 3}

    # Create training data
    X_train = []

    # Target Data
    y_train = like_decisions

    #TODO Edit actual Mapping
    for user in user_list:
        X_train.append([calculate_age(user.date_of_birth), len(user.bio),
                        gender_mapping.get(str(user.gender_identity))])

    return X_train, y_train


def users_to_x_predict(user: User):
    # Mapping dictionary for encoding gender labels
    gender_mapping = {"men": 1, "woman": 2, "divers": 3}

    # TODO Edit actual Mapping
    X_predict = [calculate_age(user.date_of_birth), len(user.bio), gender_mapping.get(str(user.gender_identity))]

    return X_predict


def calculate_age(date_of_birth):
    today = date.today()
    return today.year - date_of_birth.year - ((today.month, today.day) < (date_of_birth.month, date_of_birth.day))



