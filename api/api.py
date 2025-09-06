from flask import Flask, jsonify, request
from flask_cors import CORS
from flask_restful import Resource, Api, reqparse, fields, marshal_with
import datetime, csv, os

app = Flask(__name__)
CORS(app)
api = Api(app)

#creates csv file if not found
if not os.path.exists('transactions.csv'):
    with open('transactions.csv', mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['Transaction Date','Account Number', 'Account Holder Name', 'Amount', 'Status'])

#expected format for the POST request
transaction_args = reqparse.RequestParser()
transaction_args.add_argument('Transaction Date', type=str, required=True, help="Date cannot be blank")
transaction_args.add_argument('Account Number', type=str, required=True, help="Account number cannot be blank")
transaction_args.add_argument('Account Holder Name', type=str, required=True, help="Account Holder Name cannot be blank")
transaction_args.add_argument('Amount', type=float, required=True, help="Amount cannot be blank")
transaction_args.add_argument('Status', type=str, required=True, help="Status cannot be blank")

#expected format for GET request
transactionFields = {
    'Transaction Date':fields.String,
    'Account Number':fields.String,
    'Account Holder Name':fields.String,
    'Amount':fields.Float,
    'Status':fields.String,
}

class Transactions(Resource):
    #get request for all transactions
    @marshal_with(transactionFields)
    def get(self):
        transactions = []
        with open('transactions.csv', mode='r') as file:
            reader = csv.DictReader(file)
            for row in reader:
                transactions.append({
                    'Transaction Date': row['Transaction Date'],
                    'Account Number': row['Account Number'],
                    'Account Holder Name': row['Account Holder Name'],
                    'Amount': float(row['Amount']),
                    'Status': row['Status'],
                })
        return transactions, 200
    
    #post request to add a row in csv file
    @marshal_with(transactionFields)
    def post(self):
        args = transaction_args.parse_args()

        try:
            date = datetime.datetime.strptime(args['Transaction Date'], '%Y-%m-%d')
        except ValueError:
            return 400
        
        transaction = {
            'Transaction Date': date.strftime('%Y-%m-%d'),
            'Account Number': args['Account Number'],
            'Account Holder Name': args['Account Holder Name'],
            'Amount': args['Amount'],
            'Status': args['Status']
        }
    
        with open('transactions.csv', mode='a',newline='') as file:
            writer = csv.writer(file)
            writer.writerow([
                transaction['Transaction Date'],
                transaction['Account Number'],
                transaction['Account Holder Name'],
                transaction['Amount'],
                transaction['Status']
            ])
            return transaction, 201

#assigned url 
api.add_resource(Transactions, '/transactions')

if __name__=='__main__':
    app.run(debug=True)
