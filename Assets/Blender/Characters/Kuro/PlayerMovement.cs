using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    public CharacterController controller;
    public Animator animator;

    public float speed = 3.0f; // Walk speed
    public float sprintSpeed = 6.0f; // Run speed
    public float rotationSpeed = 10.0f;

    void Update()
    {
        // 1. Get WASD / Arrow Key input
        float horizontal = Input.GetAxis("Horizontal"); // A/D or Left/Right
        float vertical = Input.GetAxis("Vertical");     // W/S or Up/Down

        // 2. Create a movement vector based on input
        Vector3 moveDirection = new Vector3(horizontal, 0, vertical).normalized;

        if (moveDirection.magnitude >= 0.1f)
        {
            // Calculate actual speed (Sprinting or Walking)
            float currentSpeed = Input.GetKey(KeyCode.LeftShift) ? sprintSpeed : speed;

            // 3. Move the character
            controller.Move(moveDirection * currentSpeed * Time.deltaTime);

            // 4. Rotate the character to face the direction they move
            Quaternion targetRotation = Quaternion.LookRotation(moveDirection);
            transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, rotationSpeed * Time.deltaTime);
        }

        // 5. Update the Animator Blend Tree
        // If we are moving, set the "Move" parameter to a value between 0 and 1
        // (0 = Idle, 0.5 = Walk, 1 = Run)
        float moveValue = moveDirection.magnitude;
        if (moveValue > 0 && Input.GetKey(KeyCode.LeftShift)) moveValue = 1.0f;
        else if (moveValue > 0) moveValue = 0.5f;

        animator.applyRootMotion = false;
        animator.SetFloat("Move", moveValue, 0.1f, Time.deltaTime);
        animator.applyRootMotion = false;
    }
}