# ODI Programming exercise by Ben Couston, programmed in Ruby

require 'date'

# a class for the accounts

class Account

  attr_reader :name, :balance, :transactions

  # initialize the account name, balance (0) and array of transactions (empty)

  def initialize(name, balance, transactions)
    @name = name
    @balance = balance
    @transactions = transactions
  end

  # add a transaction to the array

  def add_transaction(transaction)
    @transactions << transaction
  end

  # calculate the balance of the account by analyzing transactions, with date parameter to view the balance up to that date

  def calculate_balance(by_date)
    @balance = 0.00
    @transactions.each do |t|
      if (by_date >= (Date.parse t[0]))
        if (t[2] == @name)
          @balance += t.last.to_f
        else
          @balance -= t.last.to_f
        end
        t.each {|attr| print ("#{attr}, ")}
        puts "end."
      end
    end
    puts
    puts "Total balance: #{balance}"
  end

  # view an account's details

  def view_account(by_date)
    puts
    puts "Name: #{name}"
    puts
    puts "Transactions:"
    self.calculate_balance(Date.parse by_date)
  end

end

# initialize array of accounts

@accounts = []

# split a transaction string into it's meaningful components and add new account if account(s) not recognised

def transaction_analyze(transaction)
  trans_details = transaction.split(',')
  for acc_no in 1..2
    if (@accounts.any? {|a| a.name == trans_details[acc_no]})
      @accounts.find{|a| a.name == trans_details[acc_no]}.add_transaction(trans_details)
    else
      new_account = Account.new(trans_details[acc_no],0.00,[])
      new_account.add_transaction(trans_details)
      @accounts << new_account
      puts "New account #{trans_details[acc_no]} registered"
    end
  end
  puts "Transaction registered"
end

# main

loop do

  # main menu

  puts "Welcome to the Banking Software Demo. Instructions are below: "
  puts "--- file {file location} - Input transactions from a ledger text file "
  puts "--- transaction {enter transaction} - Input each individual transaction manually "
  puts "--- access {account name} - Access specified account "
  puts "--- balance {account name},{YYYY-MM-DD} - Output balance for specified account at specified date"
  user_input = gets.chomp

  # file instruction - works best when the text file is in the same directory

  if (user_input.start_with?('file '))
    user_input.slice!('file ')
    File.open(user_input, "r").each_line do |line|
      transaction_analyze(line)
    end

  # transaction instruction

  elsif (user_input.start_with?('transaction '))
    user_input.slice!('transaction ')
    trans_details = user_input.split(',')
    transaction_analyze(user_input)

  # access instruction

  elsif (user_input.start_with?('access '))
    user_input.slice!('access ')
    if (@accounts.any? {|a| a.name == user_input})
      @accounts.find{|a| a.name == user_input}.view_account("9999-12-31")
    else
      puts "The specified account does not exist"
    end

  # balance instruction

  elsif (user_input.start_with?('balance '))
    user_input.slice!('balance ')
    date_details = user_input.split(',')
    if (@accounts.any? {|a| a.name == date_details[0]})
      @accounts.find{|a| a.name == date_details[0]}.view_account(date_details[1])
    else
      puts "The specified account does not exist"
    end

  # instruction not recognised

  else
    puts
    puts "Instruction not recognised"
  end

  puts

end