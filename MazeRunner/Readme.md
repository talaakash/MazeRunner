# SpriteKit SKPhysicsBody

## Initializers
- **circleOfRadius** → Spins up a circular hitbox for rapid deployment.

- **circleOfRadius:center** → Same circle, strategically repositioned for granular alignment.

- **rectangleOf** → Activates a rectangular collision footprint, centered for plug-and-play integration.

- **rectangleOf:center** → Rectangle with stakeholder-driven custom positioning.

- **polygonFrom** → Onboards a polygonal body derived directly from a CGPath blueprint.

- **edgeFrom:to:** → Establishes a zero-thickness collision rail between two key coordinates.

- **edgeChainFrom** → Converts a path into a linked perimeter of collision edges.

- **edgeLoopFrom(path)** → Closes the loop on an edge chain to form a full perimeter.

- **edgeLoopFrom(rect)** → Generates a rectangular boundary for streamlined world containment.

- **texture:size** → Auto-maps a physics body to opaque pixels for high-fidelity collision modeling.

- **texture:alphaThreshold:size** → Same as above, with precision gating on transparency.

- **bodies:[ ]** → Merges multiple bodies into a unified, consolidated collision asset.
---

## Core properties
- **isDynamic** → Toggles whether the body actively participates in the simulation lifecycle.

- **usesPreciseCollisionDetection** → Elevates collision accuracy for fast-moving assets.

- **allowsRotation** → Enables or restricts rotational dynamics based on game design KPIs.

- **pinned** → Hard-locks the body’s position while preserving rotation freedom.

- **isResting** → Indicates whether the simulation has deprioritized updates for this body.

- **friction** → Governs surface roughness during sliding events.

- **charge** → Defines electrical charge to interface with field effects.

- **restitution** → Controls bounce efficiency in collision outcomes.

- **linearDamping** → Bleeds off linear velocity for controlled deceleration.

- **angularDamping** → Bleeds off rotational velocity for stability.

- **density** → Establishes density, directly tied to mass calculations.

- **mass** → Explicit mass for downstream physics operations.

- **area** → Exposes the computed area for the underlying body.

- **affectedByGravity** → Declares whether gravity fields influence this asset.

- **fieldBitMask** → Specifies which field categories this body engages with.

- **categoryBitMask** → Assigns the body’s identity in the collision ecosystem.

- **collisionBitMask** → Defines which categories can physically constrain this body.

- **contactTestBitMask** → Flags which categories trigger event-level contact notifications.

- **joints** → Lists all relational joints currently binding this body.

- **node** → References the SKNode this physics instance is tethered to.

- **velocity** → Real-time linear movement vector.

- **angularVelocity** → Real-time rotational momentum metric.

---
## Force / impulse APIs
- **applyForce** → Applies ongoing directional acceleration.

- **applyForce:atPoint:** → Same force but injected at a specific leverage point.

- **applyTorque** → Injects rotational acceleration.

- **applyImpulse** → Delivers an instantaneous velocity boost.

- **applyImpulse:atPoint:** → Impulse with strategic off-center application for spin.

- **applyAngularImpulse** → Instant rotational boost.

- **allContactedBodies()** → Returns all bodies currently intersecting this one.
