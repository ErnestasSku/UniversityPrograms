public class Variable {
 String type; //Int, String, 
 String name; // name of variable i, x, y ..
 int value;   // Atm supprot only ints
 boolean iterator = false;
 int bound;
 String typeOfOperator;
}

public class Iterator extends Variable {
  int bound;  // i < 5 <- ths number
  String typeOfOperator; // ++ or --
  
}

public class Excecutor
{
   String StartOfCommand, endOfCommand;
   boolean interuption = false;
   Excecutor nextLevel;
   int timesLeft;
   
}
