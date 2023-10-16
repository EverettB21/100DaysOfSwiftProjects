//
//  GameScene.swift
//  Project 11
//
//  Created by Everett Brothers on 9/29/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var boxes: [SKSpriteNode] = []
    var scoreLabel: SKLabelNode!

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var ballLabel: SKLabelNode!
    
    var ballCount = 5 {
        didSet {
            ballLabel.text = "Balls: \(ballCount)"
        }
    }
    
    var editLabel: SKLabelNode!

    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 650)
        addChild(scoreLabel)
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 650)
        addChild(editLabel)
        ballLabel = SKLabelNode(fontNamed: "Chalkduster")
        ballLabel.text = "Balls: 5"
        ballLabel.position = CGPoint(x: 490, y: 650)
        addChild(ballLabel)
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotGlow)
        addChild(slotBase)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(object: ball)
            score += 1
            ballCount += 1
        } else if object.name == "bad" {
            destroy(object: ball)
            score -= 1
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

        if nodeA.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
        
    }
    
    func destroy(object: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = object.position
            addChild(fireParticles)
        }
        
        object.removeFromParent()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            let objects = nodes(at: location)

            if objects.contains(editLabel) {
                editingMode.toggle()
                ballCount = 5
            } else if objects.contains(ballLabel) {
                for box in boxes {
                    destroy(object: box)
                }
            } else {
                if editingMode {
                    let size = CGSize(width: Int.random(in: 16...200), height: 16)
                    let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                    box.zRotation = CGFloat.random(in: 0...3)
                    box.position = location
                    box.name = "box"

                    box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                    box.physicsBody?.isDynamic = false
                    
                    boxes.append(box)
                    
                    addChild(box)
                } else {
                    if ballCount > 0 {
                        let num = Int.random(in: 1...7)
                        let ball: SKSpriteNode
                        switch num {
                        case 1:
                            ball = SKSpriteNode(imageNamed: "ballRed")
                        case 2:
                            ball = SKSpriteNode(imageNamed: "ballBlue")
                        case 3:
                            ball = SKSpriteNode(imageNamed: "ballCyan")
                        case 4:
                            ball = SKSpriteNode(imageNamed: "ballGreen")
                        case 5:
                            ball = SKSpriteNode(imageNamed: "ballGrey")
                        case 6:
                            ball = SKSpriteNode(imageNamed: "ballPurple")
                        case 7:
                            ball = SKSpriteNode(imageNamed: "ballYellow")
                        default:
                            ball = SKSpriteNode(imageNamed: "ballRed")
                        }
                        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                        ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
                        ball.physicsBody?.restitution = 0.4
                        ball.position = CGPoint(x: location.x, y: 650)
                        ball.name = "ball"
                        addChild(ball)
                        ballCount -= 1
                    }
                }
            }
        }
    }
}
