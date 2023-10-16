//
//  GameScene.swift
//  Project 14
//
//  Created by Everett Brothers on 10/3/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    
    let possibleEnemys = ["ball", "hammer", "tv"]
    var isGameOver = false
    var gameTimer: Timer?
    var time: Double = 1
    var count = 0
    var timeBump = 20
    var playerLocation = CGPoint(x: 0, y: 0)
    var move = false
    
    var resetLabel: SKLabelNode!
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        gameTimer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
        resetLabel = SKLabelNode(fontNamed: "Chalkduster")
        resetLabel.text = "Reset"
        resetLabel.position = CGPoint(x: 512, y: 384)
        resetLabel.isHidden = true
        addChild(resetLabel)
        
        starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: 1024 , y: 384)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
    }
    
    func show(_ boo: Bool) {
        player.isHidden = boo
        scoreLabel.isHidden = boo
        resetLabel.isHidden = !boo
    }
    
    func start() {
        time = 1
        count = 0
        timeBump = 20
        playerLocation = CGPoint(x: 0, y: 0)
        move = false
        isGameOver = false
        score = 0
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
        if count > timeBump {
            time -= 0.1
            if time < 0.3 {
                time = 0.3
            }
            gameTimer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
            timeBump += 10
        }
        
        if !isGameOver {
            score += 1
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if move {
            playerLocation = touch.location(in: self)
            move = false
        }
    }
    
    @objc func createEnemy() {
        if !isGameOver {
            guard let enemy = possibleEnemys.randomElement() else { return }
            
            let sprite = SKSpriteNode(imageNamed: enemy)
            sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
            addChild(sprite)
            
            sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
            sprite.physicsBody?.categoryBitMask = 1
            sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
            sprite.physicsBody?.angularVelocity = 5
            sprite.physicsBody?.linearDamping = 0
            sprite.physicsBody?.angularDamping = 0
            
            count += 1
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        var location = touch.location(in: self)
        
        if nodes(at: location).contains(resetLabel) {
            start()
            show(false)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        var location = playerLocation
        var xLocations: [Double] = []
        var yLocations: [Double] = []
        var i = -10.0
        
        while i <= 10 {
            xLocations.append(playerLocation.x - i)
            yLocations.append(playerLocation.y - i)
            i += 1
        }
        
        for xLocation in xLocations {
            for yLocation in yLocations {
                if location.x == xLocation && location.y == yLocation {
                    location = touch.location(in: self)
                    move = true
                    break
                }
            }
        }
        
        if location.x < 100 {
            location.x = 100
        } else if location.x > 668 {
            location.x = 668
        }
        
        player.position = location
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")
        explosion?.position = player.position
        addChild(explosion!)
        
        isGameOver = true
        
        show(true)
    }
}
