# Constant Usage in Variables
MAX_TRIES = 3  # Maximum number of tries allowed

# Function Creation and Utilization
def greet_user(name):
    return f"Hello, {name}! I am ALVIS, your friendly bot."

def check_even_or_odd(number):
    if number % 2 == 0:
        return f"{number} is even."
    else:
        return f"{number} is odd."

# Decision Structures with if-else
def make_decision(user_input):
    if user_input.lower() == 'yes':
        return "Great! Let's proceed."
    else:
        return "No problem! We can try again later."

# Repetition with while Loops
def keep_trying():
    tries = 0
    while tries < MAX_TRIES:
        user_input = input("Do you want to continue? (yes/no): ")
        print(make_decision(user_input))
        if user_input.lower() == 'yes':
            break
        tries += 1

# Sequence Iteration with for Loops and List Manipulation
def show_favorites(favorites):
    for item in favorites:
        print(f"One of your favorite things is {item}.")

# File Operations (write and read)
def save_favorites_to_file(favorites, filename="favorites.txt"):
    with open(filename, "w") as file:
        for item in favorites:
            file.write(f"{item}\n")

def read_favorites_from_file(filename="favorites.txt"):
    try:
        with open(filename, "r") as file:
            return [line.strip() for line in file.readlines()]
    except FileNotFoundError:
        print(f"Error: {filename} not found!")
        return []

# Exception Handling
def get_number_from_user():
    try:
        number = int(input("Enter a number: "))
        print(check_even_or_odd(number))
    except ValueError:
        print("That's not a valid number!")
    else:
        print("Good job entering a number.")
    finally:
        print("Number processing complete.")

# Main Function to Drive the Bot
def main():
    user_name = input("What's your name? ")
    print(greet_user(user_name))

    # Show some list manipulation
    user_favorites = ['Pizza', 'Robots', 'Python']
    show_favorites(user_favorites)
    
    # Save and read favorites from file
    save_favorites_to_file(user_favorites)
    favorites_from_file = read_favorites_from_file()
    print("Your saved favorites are:")
    print(favorites_from_file)
    
    # Try getting a number from user
    get_number_from_user()
    
    # Ask if user wants to keep going
    keep_trying()

# Run the bot
if __name__ == "__main__":
    main()
