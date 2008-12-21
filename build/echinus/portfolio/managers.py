from django.db import models


class ActiveItemsManager(models.Manager):
    """
    Lists only active items
    """
    def get_query_set(self):
        return super(ActiveItemsManager, self).get_query_set().filter(active=True)
