//
//  ViewController.swift
//  Noughts And Crosses
//
//  Created by Chrishon Wyllie on 2/20/16.
//  Copyright © 2016 Chrishon Wyllie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    //1 = noughts, 2 = crosses
    var activePlayer = 1
    
    //0 = empty, 1 = noughts, 2 = crosses
    //You will use this to determine whether something already exists in a spot
    //Effectively fixes the issue of allowing players to overwrite other turns
    var gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    
    //An array of arrays
    //Used to determine which are winning conditions in the game
    //The numbers used refer to the positions in the gameState array
    //left to right, up and down, diagnonal
    let winningCombinations = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
    
    
    //Determines whether the game is still in play or not. Basically, did someone win yet?
    var gameActive = true
    
    
    
    
    //The purpose of having this IBOutlet alongside the IBAction is because
    //the Action code moves the outlet...that contains the button...
    //It's like when the button is pressed, it runs to code to move itself 
    //off the screen, etc.
    @IBOutlet weak var playAgainButton: UIButton!
    
    
    //Restarts the game by resetting the variables above and below
    @IBAction func playAgain(sender: AnyObject) {
        
        gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0]
        
        activePlayer = 1
        
        gameActive = true

        gameOverLabel.hidden = true
        
        gameOverLabel.center = CGPointMake(gameOverLabel.center.x - 500, gameOverLabel.center.y)
        
        playAgainButton.hidden = true
        
        playAgainButton.center = CGPointMake(playAgainButton.center.x - 500, playAgainButton.center.y)
        
        
        
        //Clears the actual noughts and crosses from the board, but things get complicated
        var buttonToClear: UIButton
        
        //Loops through specified number of tags that you have created. 9 = 0-8
        
        for var i = 0; i < 9; i++ {
            
            //Loops through and collects all tags
            //unwraps as a UIButton since it initially refers to it
            //as a tag
            
            /**IMPORTANT*******
            When you select all tags between 0 and 9, you must remember that some
            things in the viewController have specified 0 as their tag by default. 
            Examples include the game board, the buttons, labels and ANY OTHER ITEM 
            DRAGGED onto the viewController will have 0 as a their tag number by default.
            
            So when the game finishes, the app will crash when a user wins because this code
            will attempt to convert all items with tag numbers between 0 and 9 to buttons.
            UIimage views, labels, etc. will crash the app when they an attempt to
            convert to buttons is made on them.
            
            To prevent this, go back through the main storyboard and make sure that only specific
            items have tags within the range of 0 to 9 (or any number you specify). 
            Change the others to 10 or higher in this case
            
            ****/
            buttonToClear = view.viewWithTag(i) as! UIButton
            
            //Clears all buttons by setting it to nil
            buttonToClear.setImage(nil, forState: .Normal)
            
        }
    }
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var gameOverLabel: UILabel!
    
    
    @IBAction func buttonPressed(sender: AnyObject) {
        
        /*IMPORTANT****
        
        
        Notice that we have used sender.setImage instead of button.setImage(the name of the image/button was called "button" but as an IBOutlet)
        
        YOU MUST CONTROL CLICK AND DRAG EVERY BUTTON TO THE METHOD!
        
        This means that we "sent" this method to every object linked
        to it, by specifying "sender" instead of a explicitly named object.
        
        */
        
        
        //----------------------------------------------------------------------------------------------//
        
        
        /*ADDITIONALLY IMPORTANT x2*****
        
        You can specify the tag of an image or button in order directly 
        manipulate it here in code. This is located by clicking on the 
        image/button/etc, scrolling down to view and choosing a number for "tag"
        Every button has been set to a number from 0 - 8. (An array of 9 spaces begins with 0-8)
        

        Using the "sender.tag" method tells the sender to find which tag it is referring to when pressed.
        So, once a button is pressed, the tag reference number is passed to the gameState array. 
        Basically, if the position in the array/game is empty ( = 0), then run the code that changes the
        image. Otherwise do nothing. This prevents the ability for players to change previous turns decisions.

        */
        //Also, only run this code IF AND ONLY IF the game is still active. Otherwise, you could play
        //even after the "someone has won!" label appears on screen.
        if (gameState[sender.tag] == 0 && gameActive == true) {
            
            //Sets the gameState to the next player. Allows for turn-taking
            gameState[sender.tag] = activePlayer
        
            if activePlayer == 1 {
            
                sender.setImage(UIImage(named: "nought.png"), forState: .Normal)
                activePlayer = 2
            
            } else {
            
                sender.setImage(UIImage(named: "cross.png"), forState: .Normal)
                activePlayer = 1
            
            }
            
            //Loop through all possible winning combinations in the array "winningCombinations"
            for combination in winningCombinations {
                
                //First checks if gameState position  = 0. This implies that a player has indeed entered
                //something in that spot
                //Next, confirms that whatever was entered in the spot is equal to the next adjacent position
                //Thus determining a winner and the end of the game.
                if(gameState[combination[0]] != 0 && gameState[combination[0]] == gameState[combination[1]]  && gameState[combination[1]] == gameState[combination[2]]) {
                    
                    //Ends the game when a winner has been found.
                    gameActive = false
                    
                    //Honestly a little confusing.
                    //Basically, if the the gameState numbers equal 1 for Noughts, print...
                    if gameState[combination[0]] == 1 {
                    
                        gameOverLabel.text = "Noughts has won!"
                        
                    } else {
                    
                        gameOverLabel.text = "Crosses have won!"
                        
                    }
                    
                    //Runs function you made to end the game
                    endGame()
                    
                }
                
            }
            
            
            
            
            /****IMPORTANT*****

            The code in the following two if statements only runs if the statement above
            has satisfied its condition. In other words, the conditions of the first if statement
            were not met, so move on down to either of these if statements
            */
            
            //Check to see if the game is still active.
            //Or in other words, has anyone won the game yet?
            //if not, do this....
            if gameActive == true {
            
                gameActive = false
            
                for buttonState in gameState {
                
                    //If any of the spaces are still untouched by the user,
                    //continue on the game. The game is stil/ active
                    if buttonState == 0 {
                    
                        gameActive = true
                    
                    }
                
                }
            
                /******IMPORTANT********
                IF NEITHER OF THE IF STATEMENTS WERE MET, MOVE ON TO THIS CONDITION
                IT HAS BEEN A DRAW!!!!!!!
                if the game has ended (ie., the gameActive has been set to false), all possible spaces
                have been filled and no winner has been declared, end the game using the endGame() code and display a draw message on the label
                */
                if gameActive == false {
                
                    gameOverLabel.text = "It's a draw! :( Play again and win!"
                
                    endGame()
                
                }
                
            }
        }
        
    }
    
    
    //End game function. This allows the code within the method to be called multiple times
    //for different reasons in the code.
    func endGame() {
        
        gameOverLabel.hidden = false
        playAgainButton.hidden = false
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            
            //Again, you are in a CLOSURE, you must use "self" to refer to an object outside of it
            self.gameOverLabel.center = CGPointMake(self.gameOverLabel.center.x + 500, self.gameOverLabel.center.y)
            
            self.playAgainButton.center = CGPointMake(self.playAgainButton.center.x + 500, self.playAgainButton.center.y)
            
        })
        
    }
    
    /*THIS IS WHERE THE CODE TO HIDE THE GAMEOVERLABEL AND PLAYAGAINBUTTONS ARE*/
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        gameOverLabel.hidden = true
        
        gameOverLabel.center = CGPointMake(gameOverLabel.center.x - 500, gameOverLabel.center.y)
        
        playAgainButton.hidden = true
        
        playAgainButton.center = CGPointMake(playAgainButton.center.x - 500, playAgainButton.center.y)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

