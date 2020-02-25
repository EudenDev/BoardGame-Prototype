using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    // :: Movement
    [SerializeField, Range(0f, 100f)]
    float maxSpeed = 10F;
    [SerializeField, Range(0f, 100f)]
    float maxAcceleration = 10F, maxAirAcceleration = 1F;
    [SerializeField, Range(0f, 90f)]
    float maxGroundAngle = 25F, maxStairsAngle = 50F;
    [SerializeField, Range(0f, 100f)]
    float maxSnapSpeed = 100F; // set a bit higher or lower than max speed
    [SerializeField, Min(0f)]
    float probeDistance = 1F;
    [SerializeField]
    LayerMask probeMask = -1, stairsMask = -1;

    float minGroundDotProduct, minStairsDotProduct;
    Vector3 velocity;
    Vector3 targetVelocity;

    // :: Jump 
    [SerializeField, Range(0f, 10f)]
    float jumpHeight = 2F; // VelocY = Sqrt(-2*grav*height)
    [SerializeField, Range(0, 5)]
    int maxAirJumps = 0;

    int jumpPhase;
    bool jumpRequest;
    int stepsSinceLastGrounded, stepsSinceLastJump;
    int groundContactCount, steepContactCount;
    bool OnGround => groundContactCount > 0;
    bool OnSteep => steepContactCount > 0;
    Vector3 contactNormal, steepNormal;

    //:: Stock
    Rigidbody rb;

    private void OnValidate()
    {
        minGroundDotProduct = Mathf.Cos(maxGroundAngle * Mathf.Deg2Rad);
        minStairsDotProduct = Mathf.Cos(maxStairsAngle * Mathf.Deg2Rad);
    }

    private void Awake()
    {
        rb = GetComponent<Rigidbody>();
        OnValidate();
    }


    // Update is called once per frame
    void Update()
    {
        // We go from: Accel > Control > Veloc > Pos
        Vector2 input = new Vector2(
            Input.GetAxis("Horizontal"),
            Input.GetAxis("Vertical"));
        input = Vector2.ClampMagnitude(input, 1f);
        targetVelocity = new Vector3(input.x, 0f, input.y) * maxSpeed;
        DebugDrawVector(targetVelocity, Color.red);
        // - Jumping
        jumpRequest |= Input.GetButtonDown("Jump"); // remain True once enabled
    }

    private void FixedUpdate()
    {
        UpdateState();
        AdjustVelocity();
        // - Jumping
        if (jumpRequest)
        {
            jumpRequest = false;
            Jump();
        }
        // - Output velocity
        rb.velocity = velocity;
        ClearState();
    }

    private void ClearState()
    {
        groundContactCount = steepContactCount = 0;
        contactNormal = steepNormal = Vector3.zero;
    }

    void UpdateState()
    {
        stepsSinceLastGrounded++;
        stepsSinceLastJump++;
        // retrieve from rigidbody
        velocity = rb.velocity;
        if (OnGround || SnapToGround() || CheckStepsContacts())
        {
            stepsSinceLastGrounded = 0;
            jumpPhase = 0;
            if (groundContactCount > 0)
            {
                contactNormal.Normalize();
            }
        }
        else
        {
            contactNormal = Vector3.up;
        }
    }

    void AdjustVelocity()
    {
        Vector3 xAxis = ProjectOnContactPlane(Vector3.right).normalized;
        Vector3 zAxis = ProjectOnContactPlane(Vector3.forward).normalized;

        float currentX = Vector3.Dot(velocity, xAxis);
        float currentZ = Vector3.Dot(velocity, zAxis);

        float acceleration = OnGround ? maxAirAcceleration : maxAirAcceleration;
        float maxSpeedChange = acceleration * Time.fixedDeltaTime;

        float newX = Mathf.MoveTowards(currentX, targetVelocity.x, maxSpeedChange);
        float newZ = Mathf.MoveTowards(currentZ, targetVelocity.z, maxSpeedChange);

        velocity += xAxis * (newX - currentX) + zAxis * (newZ - currentZ);
    }

    Vector3 ProjectOnContactPlane(Vector3 vector)
    {
        return vector - contactNormal * Vector3.Dot(vector, contactNormal);
    }


    private void Jump()
    {
        if (OnGround || jumpPhase < maxAirJumps)
        {
            stepsSinceLastJump = 0;
            jumpPhase++;
            float jumpSpeed = Mathf.Sqrt(-2f * Physics.gravity.y * jumpHeight);
            float alignedSpeed = Vector3.Dot(velocity, contactNormal);
            if (alignedSpeed > 0F)
            {
                jumpSpeed = Mathf.Max(jumpSpeed - velocity.y, 0f);
            }
            velocity += contactNormal * jumpSpeed;

        }
    }

    bool SnapToGround()
    {
        if (stepsSinceLastGrounded > 1 || stepsSinceLastJump <= 2)
        { // Snap once only after loosing contact; avoid bunny hopping
            return false;
        }
        float speed = velocity.magnitude;
        if (speed > maxSnapSpeed)
        {
            return false;
        }
        if (!Physics.Raycast(
            rb.position, Vector3.down, out RaycastHit hit, probeDistance, probeMask))
        {
            return false;
        }
        if (hit.normal.y < GetMinDot(hit.collider.gameObject.layer))
        {
            return false;
        }
        groundContactCount = 1;
        contactNormal = hit.normal;
        float dot = Vector3.Dot(velocity, hit.normal);
        if (dot > 0F)
        {
            velocity = (velocity - hit.normal * dot).normalized * speed;
        }
        return true;
    }

    bool CheckStepsContacts()
    {
        if (steepContactCount > 1)
        {
            steepNormal.Normalize();
            if (steepNormal.y >= minGroundDotProduct)
            {
                groundContactCount = 1;
                contactNormal = steepNormal;
                return true;
            }
        }
        return false;
    }

    float GetMinDot(int layer)
    {
        return (stairsMask & (1 << layer)) == 0 ? minGroundDotProduct : minStairsDotProduct;
    }

    private void OnCollisionEnter(Collision collision)
    {
        EvaluateCollision(collision);
    }

    // OnEnter and Exit are sent when it touches another collider
    private void OnCollisionStay(Collision collision)
    {
        EvaluateCollision(collision);
    }

    private void EvaluateCollision(Collision collision)
    {
        float minDot = GetMinDot(collision.gameObject.layer);
        for (int i = 0; i < collision.contactCount; i++)
        {
            Vector3 normal = collision.GetContact(i).normal;
            if (normal.y >= minDot)
            {
                groundContactCount++;
                contactNormal += normal;
            }
            else if (normal.y > -0.01F)
            {
                steepContactCount++;
                steepNormal += normal;
            }
        }
    }

    public bool debugRays = true;

    void DebugDrawVector(Vector3 vector, Color color)
    {
        if (!debugRays) { return; }
        Debug.DrawRay(transform.position, vector, color);
    }

    void DebugDrawVector(Vector3 origin, Vector3 vector, Color color)
    {
        if (!debugRays) { return; }
        Debug.DrawLine(origin, origin + vector, color);
    }
}
