# Compiler Design with Lex & Yacc: Symbol Table Interpreter  

This project demonstrates the use of **Lex** and **Yacc** to design a mini language interpreter, implementing a **symbol table** to store variable assignments and perform arithmetic operations. The interpreter processes a custom `.rup` file format for variable assignments, basic arithmetic, and print statements.  

### Features 🌟  
- **Variable Assignment**: Support for assigning values to variables.  
- **Arithmetic Operations**: Perform basic addition and subtraction (note: does not follow operator precedence).  
- **Printing Results**: Ability to print variables or computed results.  
- **Graceful Exit**: Command to terminate execution.  

### Symbol Table 📚  
The **Symbol Table** is implemented using a **linked list**, where each node stores:  
- `id`: Variable name  
- `num`: Variable value  
- A pointer to the next node (for chaining)  

The table supports storing and retrieving variable values, and ensures that undefined variables are flagged with an error.

### Grammar 📜  
The grammar for the mini language is defined in **Yacc (`parser.y`)**. Here’s a basic overview:  

```yacc
line    : assignment '~'  
        | exit_cmd '~'  
        | print exp '~'  
        | line assignment '~'  
        | line print exp '~'  
        | line exit_cmd '~';  

assignment : identifier '=' exp;  

exp     : term  
        | exp '+' term  
        | exp '-' term;  

term    : number  
        | identifier;  
```  

Note: This grammar does **not** follow **operator precedence**, and expressions are evaluated strictly from left to right.  

### How It Works 🏗️  
The project includes two key components:  

1. **Scanner (`scanner.l`)**: The scanner handles tokenizing the input. It identifies keywords like `print`, `exit`, numbers, operators, and variable names.  
2. **Parser (`parser.y`)**: The parser processes the tokens, applies grammar rules, and invokes functions like `updateTable()` for variable assignments and arithmetic computations.

### Running the Interpreter 🏃‍♂️  
1. **Create a `.rup` File**: Write your program in a `.rup` file, such as:  
   ```  
   a = 5 ~  
   b = a + 10 ~  
   print b ~  
   exit ~  
   ```  

2. **Compile the Interpreter**:  
   Run the following commands to compile the Lex and Yacc files:  
   ```bash  
   lex scanner.l  
   yacc -d parser.y  
   gcc y.tab.c lex.yy.c -o rupc  
   ```  

3. **Run the Code**:  
   Execute your `.rup` file using the interpreter:  
   ```bash  
   ./rupc <filename>.rup  
   ```  

`./rupc` acts as an **interpreter** that reads the `.rup` file, tokenizes the input, parses it, and executes the instructions sequentially.

