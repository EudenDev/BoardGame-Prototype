using UnityEngine;
// ANDRES

/// <summary>
/// Creates a timer that goes from zero to Time Amount.
/// Use <see cref="Check"/> to move this timer.
/// </summary>
[System.Serializable]
public class SimpleTimer
{
    //:: External Settings
    [Tooltip("In seconds, duration of this timer")]
    [SerializeField]
    private float m_timeAmount = 30f;

    [Tooltip("Remaining time or where to begin counting from.")]
    [SerializeField]
    private float m_currentTime;

    /// <summary>
    /// Use <see cref="Time.unscaledDeltaTime"/> to move this timer?
    /// </summary>
    public bool UseUnscaledTime { set; get; }

    /// <summary>
    /// Moves this <see cref="T:SimpleTimer"/> then returns its current time. <para></para>
    /// Sets a value clamped between zero and <see cref="TimeAmount"/>
    /// </summary>
    public float CurrentTime
    {
        set { m_currentTime = Mathf.Clamp(value, 0f, m_timeAmount); }
        get
        {
            Check();
            return m_currentTime;
        }
    }

    /// <summary>
    /// Current time in this timer, use <see cref="Check"/> to update it.
    /// Or <see cref="CurrentTime"/>.
    /// </summary>
    public float CurrentTimeFixed => m_currentTime;

    /// <summary>
    /// Duration of this timer.
    /// </summary>
    public float TimeAmount
    {
        set { m_timeAmount = value; }
        get { return m_timeAmount; }
    }

    /// <summary>
    /// Gets the normalized (0 to 1) value of the timer.
    /// This does NOT move the <see cref="T:SimpleTimer"/>
    /// </summary>
    public float NormalizedFixed => m_currentTime / m_timeAmount;

    /// <summary>
    /// Moves this <see cref="T:SimpleTimer"/> then 
    /// returns the normalized (0 to 1) value of the timer.
    /// <para></para>
    /// This can be passed to an easing or lerp function to get desired motions.
    /// </summary>
    public float Normalized
    {
        get
        {
            Check();
            return NormalizedFixed;
        }
    }

    /// <summary>
    /// Returns TRUE is this <see cref="T:SimpleTimer"/> instance is over.
    /// Use <see cref="Reset"/> to reuse this timer.
    /// </summary>
    public bool HasStopped { get; private set; } = false;

    // :: Public Methods ::

    /// <summary>
    /// Sets a Timer that goes from zero to specified time in seconds.
    /// </summary>
    /// <param name="seconds">Values over 60 are accepted</param>
    /// <param name="unscaledTime">Use unscaled time instead</param>
    public SimpleTimer(float seconds, bool unscaledTime = false)
    {
        m_timeAmount = seconds;
        m_currentTime = 0f;
        UseUnscaledTime = unscaledTime;
    }

    /// <summary>
    /// Moves this timer instance with a given delta time, then
    /// returns whether or not this timer is over.
    /// </summary>
    /// <param name="deltaTime">Time step to progress.</param>
    /// <returns>Returns whether or not this timer is over.</returns>
    public bool Check(float deltaTime)
    {
        if (HasStopped) { return true; }
        // - 
        m_currentTime = Mathf.MoveTowards(m_currentTime, m_timeAmount, deltaTime);
        HasStopped = System.Math.Abs(m_currentTime - m_timeAmount) < float.Epsilon;
        return HasStopped;
    }

    /// <summary>
    /// Same as <see cref="Check(float)"/> but automatically set its delta time
    /// according to <seealso cref="UseUnscaledTime"/> property.
    /// </summary>
    public bool Check()
    {
        float dt = UseUnscaledTime ? Time.unscaledDeltaTime : Time.deltaTime;
        return Check(dt);
    }

    /// <summary>
    /// Sets the timer back to zero and removes the <see cref="HasStopped"/> flag.
    /// </summary>
    public void Reset()
    {
        m_currentTime = 0f;
        HasStopped = false;
    }

    public override string ToString() => m_currentTime.ToString();

}

/* CHANGELOG
 * [jan2020] v3.0.0 simplification, custom delta time on Check() method.
 * [apr2019] v2.0.0 fixed main bug :( Alos compatible with negative values
 * [mar2019] v1.0.0 first version
*/

    // ++ We could use this as base and inherit Timer.
    // ++ If so this should be timer and the other, TimerAdvanced