# Coupons-Parser

This Parser will read the json file and evaluate it's expression in sting format and it will check if the conditions are correct or not.


e.g Below is json file.
-------
{
  "data": [
    {
      "name": "Purchase Coke as a Female and have less than 500 points",
      "id": "TC-02762",
      "data": [
        {
          "op": "AND",
          "condition": "Product.code == 'A-0022'"
        },
        {
          "op": "AND",
          "condition": "'DateofPurchase.Month' == 11, 'DateofPurchase.Day' between 16, 30"
        },
        {
          "op": "AND",
          "condition": "`Gender` == 'Female'"
        },
        {
          "op": "AND",
          "condition": "`Points` < 500"
        }
      ]
    },
    {
      "name": "If you buy a Coke (A_0022)",
      "id": "TC-01267",
      "data": [
        {
          "op": "AND",
          "condition": "Product.code == 'A-0022'"
        }
      ]
    },
    {
      "name": "Male Purchase 3000 or more between 1st to 31st of this month",
      "id": "TC-01267",
      "data": [
        {
          "op": "AND",
          "condition": "'DateofPurchase.Day' between 1, 31"
        },
        {
          "op": "AND",
          "condition": "'DateofPurchase.Month' == 'ThisMonth'"
        },
        {
          "op": "AND",
          "condition": "'PurchaseThisMonth' >= 3000"
        },
        {
          "op": "AND",
          "condition": "'Gender' == 'Male'"
        }
      ]
    }
  ]
}

this parser will evaluate all expression and gives us final result.
