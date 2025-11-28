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

- Here 1 is circular body, 2 is rectangular, 3 is polygon and 4 is texture.

![Alternative Text](https://miro.medium.com/v2/resize:fit:1400/format:webp/1*8MyAQOqHuD0cP-IbHCBqqA@2x.png)
---
## Core properties
- **isDynamic** → Toggles whether the body actively participates in the simulation lifecycle like moving, rotating, etc.

- **usesPreciseCollisionDetection** → Elevates collision accuracy for fast-moving assets.

- **allowsRotation** → Enables or restricts rotational dynamics based on game design KPIs.

- **pinned** → Hard-locks the body’s position while preserving rotation freedom.

- **isResting** → Indicates whether the simulation has deprioritized updates for this body. This is done by system and if we apply some velocity or something then again it prioritize it)

- **friction** → Governs surface roughness during sliding events. High friction (e.g., 1.0+) The object “grips” the surface, Low friction (e.g., 0.0–0.2) The object slides easily,

- **charge** → Defines electrical charge to interface with field effects. magnet like effect attract 2 dynamic physics if it have opposite value and if same value then move away.

- **restitution** → Controls bounce efficiency in collision outcomes. (0.0 - 1.0)

- **linearDamping** → slows down movement over time.

- **angularDamping** → slows down rotation.

- **density** → Establishes density, directly tied to mass calculations. How “heavy” the object is per unit of area.

- **mass** → The actual total weight of the object inside the physics simulation. (Auto computed unless we override it), **formula**: mass = density * area

- **area** → Exposes the computed area for the underlying body (Get only Property). Calculated automatically based on the body shape and size.

- **affectedByGravity** → Declares whether gravity fields influence this asset.

- **fieldBitMask** → Specifies which field categories this body engages with.

- **categoryBitMask** → Assigns the body’s identity in the collision ecosystem.

- **collisionBitMask** → Defines which categories can physically constrain this body.

- **contactTestBitMask** → Flags which categories trigger event-level contact notifications.

- **joints** → Lists all relational joints currently binding this body.
    1. **Fixed Joint:** Two bodies are locked into a single rigid relationship — no separation, no movement relative to each other.
    2. **Pin Joint:** Bodies rotate around one anchor point — like a door hinge.
    3. **Spring Joint:** Bodies pull toward each other with a spring-like behavior.
    4. **Sliding Joint:** Bodies can slide back and forth along a fixed axis.
    5. **Limit Joint:** Bodies can move freely until they hit the minimum/maximum allowed distance.


- **node** → References the SKNode this physics instance is tethered to.

- **velocity** → Real-time linear movement vector.

- **angularVelocity** → Real-time rotational momentum metric.

# SKPhysicsBody – Core Properties Overview

| Property | Type | Default | Impact Area | Description |
| --- | --- | --- | --- | --- |
| `isDynamic` | Bool | true | Movement | Determines whether the body responds to forces, impulses, and collisions. |
| `affectedByGravity` | Bool | true | Movement | Enables or disables gravitational acceleration on the body. |
| `allowsRotation` | Bool | true | Rotation | Determines whether the body can rotate based on applied torque or collisions. |
| `mass` | CGFloat | Auto | Movement | Governs how much force is required to accelerate the body. |
| `area` | CGFloat | Auto (Get only Property) | Movement | Exposes the computed area for the underlying body. Calculated automatically based on the body shape and size. |
| `density` | CGFloat | Auto | Movement | Defines mass per unit area; used to calculate mass when not manually set. |
| `friction` | CGFloat | 0.2 | Sliding | Controls how easily the body slides along other surfaces. |
| `restitution` | CGFloat | 0.2 | Bounce | Governs how much energy is lost or retained during a collision (bounciness). |
| `linearDamping` | CGFloat | 0.1 | Movement | Slows down the velocity of the body over time (air resistance). |
| `angularDamping` | CGFloat | 0.1 | Rotation | Slows down rotational velocity over time. |
| `velocity` | CGVector | .zero | Movement | Specifies the body’s current movement vector. |
| `angularVelocity` | CGFloat | 0 | Rotation | Specifies the body’s current rotational speed. |
| `charge` | CGFloat | 0 | Force Field | Enables electromagnetic-style attraction/repulsion. |
| `fieldBitMask` | UInt32 | all bits | Field Interaction | Dictates which fields influence this body. |
| `collisionBitMask` | UInt32 | Auto | Collision | Specifies which categories this body physically collides with. |
| `contactTestBitMask` | UInt32 | 0 | Contact Events | Specifies which categories trigger contact callbacks. |
| `categoryBitMask` | UInt32 | 0xFFFFFFFF | Physics Category | Defines the body’s identity in the collision matrix. |
| `usesPreciseCollisionDetection` | Bool | false | Collision | Improves accuracy for fast-moving bodies (higher cost). |
| `pinned` | Bool | false | Movement | Locks the body in place while still allowing rotation. |
| `allowsResting` | Bool | true | Optimization | Allows body to sleep when motion falls below thresholds. |
| `isResting` | Bool | false | State | Indicates whether the body is currently asleep (auto-managed). |
| `centerOfMass` | CGPoint | Auto | Dynamics | Location where physics forces apply relative to body frame. |
| `joints` (via scene) | [SKPhysicsJoint] | — | Constraints | Connects bodies with behavior-defined constraints. |

---
## Force / impulse APIs
- **applyForce** → Applies a continuous push to the body over time.

- **applyForce:atPoint:** → Applies force at a specific point on the body, not at the center.

- **applyTorque** → Applies a continuous rotational force.

- **applyImpulse** → Applies a sudden, instant burst of force.

- **applyImpulse:atPoint:** → Same instant burst, but at a specific point.

- **applyAngularImpulse** → Instant rotational “kick”. Angular impulse = instant spin.

- **allContactedBodies()** → Returns all physics bodies currently touching this body.

| Method | Continuous or Instant | Movement | Rotation | Point-based |
| --- | --- | --- | --- | --- |
| `applyForce` | Continuous | ✔️ | ❌ | Center |
| `applyForce:atPoint` | Continuous | ✔️ | ✔️ | ✔️ |
| `applyTorque` | Continuous | ❌ | ✔️ | — |
| `applyImpulse` | Instant | ✔️ | ❌ | Center |
| `applyImpulse:atPoint` | Instant | ✔️ | ✔️ | ✔️ |
| `applyAngularImpulse` | Instant | ❌ | ✔️ | — |
| `allContactedBodies()` | N/A | — | — | — |
