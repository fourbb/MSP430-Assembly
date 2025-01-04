# MSP430-Assembly
This project was developed using an MSP430 microcontroller and programmed in Assembly language. The primary goal was to design a simple yet interactive game using a 7-segment LED display. The components used in the project include:
•	2 buttons
•	2 LEDs
•	1 breadboard
•	1 7-segment LED display
•	1 MSP430 microcontroller
Game Description:
The game starts with the 7-segment LED display counting down from 3 to 0. Once the countdown reaches zero, the display shows a dash (-). At this point, players need to press their respective buttons as quickly as possible.
The player who presses their button first will see their corresponding LED light up, indicating that they have won the game. If a player presses their button before the dash (-) appears, the opponent’s LED will light up instead, signaling that the opponent has won the round.
Simultaneous Button Press Prevention:
An additional safety feature has been implemented to ensure fairness during the game. If both players press their buttons at nearly the same time (or simultaneously), the game will only recognize the input from the first button pressed. Once one button is detected, any subsequent presses—even if they occur a fraction of a second later—will be ignored until the game resets.
This mechanism ensures that the game is fair and avoids potential conflicts or ambiguity in determining the winner. The logic is implemented using interrupts, which allow the microcontroller to prioritize the first detected button press and disregard any further inputs until the current round is completed.
Game Reset and Continuity:
After each round, the game automatically resets itself, beginning the countdown again. This automated reset eliminates the need for manual intervention and ensures smooth, continuous gameplay.
In conclusion, this project showcases the practical use of the MSP430 microcontroller, Assembly programming, and simple hardware components to create an engaging, interactive, and fair game. It demonstrates effective use of interrupt-driven programming to handle precise inputs and avoid simultaneous button press conflicts.

