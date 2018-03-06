//
//  GameScene.swift
//  Rain
//
//  Created by Joseph Hinkle on 11/13/17.
//  Copyright © 2017 Joseph Hinkle. All rights reserved.
//

import SpriteKit
import GameplayKit
import QuartzCore

class GameScene: SKScene {
    
    private var playButton : SKSpriteNode?
    private var creditsButton : SKSpriteNode?
    private var rainDrops : [SKSpriteNode] = [SKSpriteNode]()
    
    private var backgroundMenu : SKSpriteNode?
    private var titleMenu : SKSpriteNode?
    
    private var backgroundCredits : SKSpriteNode?
    private var creditsBackButton : SKSpriteNode?
    
    private var backgroundGame : SKSpriteNode?
    private var gameBackButton : SKSpriteNode?
    
    
    private var player : SKSpriteNode?
    private var platL1 : SKSpriteNode?
    private var platL2 : SKSpriteNode?
    private var platR1 : SKSpriteNode?
    private var platR2 : SKSpriteNode?
    private var plats : [SKSpriteNode] = [SKSpriteNode]()
    private var countDown : SKLabelNode?
    private var scoreLabel : SKLabelNode?
    
    // game variables
    private var gameIsReady = false
    private var totalTimeGameRunning = 0
    private var gameStart = false
    private var gameFallSpeed:CGFloat = 0
    // player
    private var playerSpeedX:CGFloat = 0.0
    private var playerSpeedY:CGFloat = 0.0
    private var isPushingLeft = false
    private var isPushingRight = false
    
    override func didMove(to view: SKView) {
        
        // get ui view references
        self.playButton = self.childNode(withName: "//SKSpriteNodePlay") as? SKSpriteNode
        self.creditsButton = self.childNode(withName: "//SKSpriteNodeCredits") as? SKSpriteNode
        self.titleMenu = self.childNode(withName: "//SKSpriteNodeTitle") as? SKSpriteNode
        self.backgroundMenu = self.childNode(withName: "//SKSpriteNodeMenuBackground") as? SKSpriteNode
        self.backgroundGame = self.childNode(withName: "//SKSpriteNodeGameBackground") as? SKSpriteNode
        self.backgroundCredits = self.childNode(withName: "//SKSpriteNodeCreditsBackground") as? SKSpriteNode
        self.gameBackButton = self.childNode(withName: "//SKSpriteNodeBackButtonGameScreen") as? SKSpriteNode
        self.creditsBackButton = self.childNode(withName: "//SKSpriteNodeBackButtonCreditsScreen") as? SKSpriteNode
        
        // get game view references
        self.player = self.childNode(withName: "//SKSpriteNodePlayer") as? SKSpriteNode
        self.platL1 = self.childNode(withName: "//SKSpriteNodePlatL1") as? SKSpriteNode
        self.platL2 = self.childNode(withName: "//SKSpriteNodePlatL2") as? SKSpriteNode
        self.platR1 = self.childNode(withName: "//SKSpriteNodePlatR1") as? SKSpriteNode
        self.platR2 = self.childNode(withName: "//SKSpriteNodePlatR2") as? SKSpriteNode
        plats.append(platL1!)
        plats.append(platL2!)
        plats.append(platR1!)
        plats.append(platR2!)
        self.countDown = self.childNode(withName: "//SKLabelCountDown") as? SKLabelNode
        self.countDown?.text = ""
        self.scoreLabel = self.childNode(withName: "//SKLabelScore") as? SKLabelNode
        self.scoreLabel?.text = ""
        
        
        // make raindrops
        for _ in 0...50 {
            let drop = SKSpriteNode.init(texture:SKTexture(imageNamed: "droplet_0" + String((arc4random_uniform(3)+1))))
            addChild(drop)
            drop.position.x = CGFloat(arc4random_uniform(UInt32(self.size.width*1.5))) - self.size.width*0.75
            drop.position.y = CGFloat(arc4random_uniform(UInt32(self.size.height*1.5))) - self.size.height*0.75
            drop.zPosition = -1
            rainDrops.append(drop)
        }
        
        // game is ready to use update func
        gameIsReady = true
        
    }
    
    
    func doesPointTouchObject(point:CGPoint, object:SKSpriteNode, scale:CGFloat) -> Bool {
        let leftBounds = object.position.x - object.size.width*0.5*scale
        let rightBounds = object.position.x + object.size.width*0.5*scale
        let topBounds = object.position.y - object.size.height*0.5*scale
        let bottomBounds = object.position.y + object.size.height*0.5*scale
        if ((point.x > leftBounds) && (point.x < rightBounds) && (point.y > topBounds) && (point.y < bottomBounds)) {
            return true
        } else {
            return false
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        // if you tap the play button
        if doesPointTouchObject(point: pos, object: self.playButton!, scale: CGFloat(3.0)) {
            menuToGame()
        }
        // if you tap the credits button
        if doesPointTouchObject(point: pos, object: self.creditsButton!, scale: CGFloat(3.0)) {
            menuToCredits()
        }
        // if you tap the credits menu back button
        if doesPointTouchObject(point: pos, object: self.creditsBackButton!, scale: CGFloat(3.0)) {
            creditsToMenu()
        }
        // if you tap the game screen back button
        if doesPointTouchObject(point: pos, object: self.gameBackButton!, scale: CGFloat(3.0)) {
            gameToMenu()
        }
        //
        // in game code //
        //
        if (gameStart) {
            if (pos.x > 0) {
                isPushingLeft = false
                isPushingRight = true
            } else {
                isPushingLeft = true
                isPushingRight = false
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
        // in game code //
        //
        if (gameStart) {
            // stop controls
            isPushingLeft = false
            isPushingRight = false
        }
    }
    
    ////////////////
    // UI CHANGES //
    ////////////////
    func menuToGame() {
        // move display objects
        backgroundMenu?.run(SKAction.move(to: CGPoint(x:0,y:self.size.height), duration: 1))
        titleMenu?.run(SKAction.move(to: CGPoint(x:0,y:self.size.height), duration: 1))
        playButton?.run(SKAction.move(to: CGPoint(x:0,y:self.size.height), duration: 1))
        creditsButton?.run(SKAction.move(to: CGPoint(x:0,y:self.size.height), duration: 1))
        backgroundGame?.run(SKAction.move(to: CGPoint(x:0,y:0), duration: 1))
        gameBackButton?.run(SKAction.move(to: CGPoint(x:-self.size.width*0.5+(gameBackButton?.size.width)!*0.5,y:self.size.height*0.5-(gameBackButton?.size.height)!*0.5), duration: 1))
        
        // reset game
        totalTimeGameRunning = 0
        gameFallSpeed = 0
        gameStart = true
    }
    func menuToCredits() {
        // move display objects
        backgroundMenu?.run(SKAction.move(to: CGPoint(x:-self.size.width,y:0), duration: 1))
        titleMenu?.run(SKAction.move(to: CGPoint(x:-self.size.width,y:0), duration: 1))
        playButton?.run(SKAction.move(to: CGPoint(x:-self.size.width,y:0), duration: 1))
        creditsButton?.run(SKAction.move(to: CGPoint(x:-self.size.width,y:0), duration: 1))
        backgroundCredits?.run(SKAction.move(to: CGPoint(x:0,y:0), duration: 1))
        creditsBackButton?.run(SKAction.move(to: CGPoint(x:-self.size.width*0.5+(creditsBackButton?.size.width)!*0.5,y:self.size.height*0.5-(creditsBackButton?.size.height)!*0.5), duration: 1))
        self.countDown?.numberOfLines = 3
        self.countDown?.xScale = 0.5
        self.countDown?.yScale = 0.5
        self.countDown?.text = "Joseph Hinkle\nSteve Ma\nRachel Pullen"
    }
    func creditsToMenu() {
        // move display objects
        backgroundMenu?.run(SKAction.move(to: CGPoint(x:0,y:0), duration: 1))
        titleMenu?.run(SKAction.move(to: CGPoint(x:0,y:386), duration: 1))
        playButton?.run(SKAction.move(to: CGPoint(x:0,y:-143.5), duration: 1))
        creditsButton?.run(SKAction.move(to: CGPoint(x:0,y:-303.5), duration: 1))
        backgroundCredits?.run(SKAction.move(to: CGPoint(x:self.size.width,y:0), duration: 1))
        creditsBackButton?.run(SKAction.move(to: CGPoint(x:self.size.width*0.5+(creditsBackButton?.size.width)!*0.5,y:self.size.height*0.5-(creditsBackButton?.size.height)!*0.5), duration: 1))
        self.countDown?.text = ""
        self.countDown?.xScale = 1
        self.countDown?.yScale = 1
    }
    
    func gameToMenu() {
        // move display objects
        backgroundMenu?.run(SKAction.move(to: CGPoint(x:0,y:0), duration: 1))
        titleMenu?.run(SKAction.move(to: CGPoint(x:0,y:386), duration: 1))
        playButton?.run(SKAction.move(to: CGPoint(x:0,y:-143.5), duration: 1))
        creditsButton?.run(SKAction.move(to: CGPoint(x:0,y:-303.5), duration: 1))
        backgroundCredits?.run(SKAction.move(to: CGPoint(x:self.size.width,y:0), duration: 1))
        creditsBackButton?.run(SKAction.move(to: CGPoint(x:self.size.width*0.5+(creditsBackButton?.size.width)!*0.5,y:self.size.height*0.5-(creditsBackButton?.size.height)!*0.5), duration: 1))
        gameBackButton?.run(SKAction.move(to: CGPoint(x:-self.size.width*0.5+(gameBackButton?.size.width)!*0.5,y:0-self.size.height-(gameBackButton?.size.height)!*0.5), duration: 1))
        
        self.countDown?.text = ""
        self.scoreLabel?.text = ""
        
        // put platform back
        platL1?.run(SKAction.move(to: CGPoint(x:-self.size.width*0.5,y:-self.size.height*1.25), duration: 1))
        platL2?.run(SKAction.move(to: CGPoint(x:-self.size.width*0.5,y:-self.size.height*1.25), duration: 1))
        platR1?.run(SKAction.move(to: CGPoint(x:self.size.width*0.5,y:-self.size.height*1.25), duration: 1))
        platR2?.run(SKAction.move(to: CGPoint(x:self.size.width*0.5,y:-self.size.height*1.25), duration: 1))
        
        // stop game
        gameStart = false
    }
    
    func gameOver() {
        // stop game
        gameStart = false
        // set text
        self.countDown?.text = "Game Over!"
        // set platform positions off screen
        platL1?.run(SKAction.move(to: CGPoint(x:-self.size.width,y:(platL1?.position.y)!), duration: 0.1))
        platL2?.run(SKAction.move(to: CGPoint(x:-self.size.width,y:(platL2?.position.y)!), duration: 0.1))
        platR1?.run(SKAction.move(to: CGPoint(x:self.size.width,y:(platR1?.position.y)!), duration: 0.1))
        platR2?.run(SKAction.move(to: CGPoint(x:self.size.width,y:(platR2?.position.y)!), duration: 0.1))
    }
    
    ///////////////
    // GAME LOOP //
    ///////////////
    var rainSpeed = CGFloat(10.0)
    var rainSpeedDirection = CGFloat(1.0)
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if gameIsReady {
            // vary rain speed
            rainSpeed += rainSpeedDirection*0.1
            if (rainSpeed > 20.0) {
                rainSpeedDirection = -1.0
            } else if (rainSpeed < 10.0) {
                rainSpeedDirection = 1.0
            }
            // move rain drops
            for rainDrop in self.rainDrops {
                rainDrop.position.x -= rainSpeed * 0.75470958022
                rainDrop.position.y -= rainSpeed * 0.65605902899
                if rainDrop.position.x < -self.size.width*0.75 {
                    rainDrop.position.x += self.size.width*1.5
                }
                if rainDrop.position.y < -self.size.height*0.75 {
                    rainDrop.position.y += self.size.height*1.5
                }
            }
            //
            // main game code
            //
            if (gameStart) {
                // update score text
                if (totalTimeGameRunning > 250) {
                    scoreLabel?.text = "Score: " + String(floor(Double(totalTimeGameRunning-250)*0.1))
                }
                // countdown
                if (totalTimeGameRunning > 300) {
                    self.countDown?.text = ""
                } else if (totalTimeGameRunning > 250) {
                    self.countDown?.text = "GO!"
                    // start moving plats
                    gameFallSpeed = 5
                } else if (totalTimeGameRunning > 200) {
                    self.countDown?.text = "1"
                } else if (totalTimeGameRunning > 150) {
                    self.countDown?.text = "2"
                } else if (totalTimeGameRunning > 100) {
                    self.countDown?.text = "3"
                    // set player position
                    player?.run(SKAction.move(to: CGPoint(x:self.size.width*0.25,y:self.size.height*0.25), duration: 0.1))
                    // set platform positions
                    platL1?.run(SKAction.move(to: CGPoint(x:-self.size.width*0.5,y:self.size.height*0.25), duration: 0.1))
                    platL2?.run(SKAction.move(to: CGPoint(x:-self.size.width*0.5,y:-self.size.height*0.25), duration: 0.1))
                    platR1?.run(SKAction.move(to: CGPoint(x:self.size.width*0.5,y:0), duration: 0.1))
                    platR2?.run(SKAction.move(to: CGPoint(x:self.size.width*0.5,y:-self.size.height*0.5), duration: 0.1))
                    // score label reset
                    self.scoreLabel?.text = "Score: 0"
                } else {
                    self.countDown?.text = ""
                }
                
                // game has actually started (the countdown ended)
                if (totalTimeGameRunning > 250) {
                    // move raindrop according to controls
                    playerSpeedX += (isPushingRight ? 1 : (isPushingLeft ? -1 : 0))
                    
                    // move player
                    player?.position.y = (player?.position.y)! - abs(sin((player?.zRotation)!)*20)
                    player?.position.x = (player?.position.x)! + playerSpeedX
                    player?.position.y = (player?.position.y)! + playerSpeedY
                    
                    // edges
                    if (player?.position.y)! < -self.size.height*0.5 {
                        player?.position.y = -self.size.height*0.5
                    }
                    if (player?.position.x)! > self.size.width*0.5 {
                        player?.position.x = self.size.width*0.5
                    } else if (player?.position.x)! < -self.size.width*0.5 {
                        player?.position.x = -self.size.width*0.5
                    }
                    
                    // detect if drop is touching platforms
                    var playerIsTouchingGround = false
                    for plat in plats {
                        // move plat
                        plat.position.y = plat.position.y + gameFallSpeed
                        // platform goes off screen
                        if (plat.position.y > self.size.height * 0.6) {
                            // reposition platform
                            if plat.position.x < 0 {
                                // randomize but keep on left
                                plat.position.x = -plat.size.width*0.35-self.size.width*0.5 + CGFloat(arc4random_uniform(UInt32(plat.size.width*0.55)))
                            } else {
                                // randomize but keep on right
                                plat.position.x = plat.size.width*0.35+self.size.width*0.5 - CGFloat(arc4random_uniform(UInt32(plat.size.width*0.55)))
                            }
                            plat.position.y = -self.size.height * 0.6
                            // increase speed
                            gameFallSpeed += 0.3
                        }
                        // hittest
                        let hitPlat = doesPointTouchObject(point: (player?.position)!, object: plat, scale: 1)
                        if (hitPlat) {
                            player?.position.y = plat.position.y + plat.size.height*0.5
                            playerSpeedY = gameFallSpeed
                        }
                        playerIsTouchingGround = playerIsTouchingGround || hitPlat
                    }
                    
                    if (playerIsTouchingGround) {
                        // physics for if player is touching the ground
                        playerSpeedX = playerSpeedX*0.86
                    } else {
                        // physics for if player is in the air
                        playerSpeedX = playerSpeedX*0.9
                        playerSpeedY -= 1
                    }
            
                    // game over
                    if (player?.position.y)! > self.size.height*0.55 {
                        gameOver()
                    }
                    
                    // rotate the player by his movement speed
                    player?.zRotation = playerSpeedX*0.17
                    player?.position.y = (player?.position.y)! + abs(sin((player?.zRotation)!)*20)
                }
                
                // increment frame counter
                totalTimeGameRunning += 1
            }
        }
    }
}
