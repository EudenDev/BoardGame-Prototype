using UnityEngine;

// ANDRES

/// <summary>
/// Creates a timer that goes from zero to Time Amount
/// Simplier version of <see cref="Timer"/>, more features available in 
/// <see cref="Timer"/> class
/// </summary>
[System.Serializable]
public class SimpleTimer
{
    //:: External Settings
    [Tooltip("In seconds, the time to reach from")]
    [SerializeField]
    private float m_timeAmount = 30f;
    [SerializeField]
    private float m_currentTime;
    private bool hasStopped = false;

    /// <summary>
    /// Moves this <see cref="T:SimpleTimer"/> then returns the current time.
    /// Modifications clamped between zero and <see cref="TimeAmount"/>
    /// </summary>
    public float CurrentTime
    {
        set { ModifyCurrentTime(value); }
        get
        {
            UpdateAndCheck();
            return m_currentTime;
        }
    }

    /// <summary>
    /// Current time in this timer,  use <see cref="Check"/> to update it.
    /// Or <see cref="CurrentTime"/> if per-update-use is intended.
    /// </summary>
    public float CurrentTimeFixed
    {
        get { return m_currentTime; }
    }

    /// <summary>
    /// Amount of time in this timer. Not modifiable below <see cref="CurrentTime"/>.
    /// </summary>
    public float TimeAmount
    {
        set { ModifyTimeAmount(value); }
        get { return m_timeAmount; }
    }

    public bool UseUnscaledTime { set; get; }

    /// <summary>
    /// Gets the normalized (0 to 1) value of the timer.
    /// This does NOT move the <see cref="T:SimpleTimer"/>
    /// </summary>
    public float NormalizedFixed
    {
        get { return m_currentTime / m_timeAmount;/*1f - ((m_timeAmount - m_currentTime) / m_timeAmount);*/ }
    }

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
            UpdateAndCheck();
            return NormalizedFixed;
        }
    }

    /// <summary>
    /// Moves this <see cref="T:SimpleTimer"/> then 
    /// returns whether or not this <see cref="T:SimpleTimer"/> is over.
    /// </summary>
    /// <value><c>true</c> if is over; otherwise, <c>false</c>.</value>
    public bool Check
    {
        get { return UpdateAndCheck(); }
    }

    public bool CheckFixed
    {
        get { return hasStopped; }
    }

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
    /// Resets the timer to its construction values.
    /// </summary>
    public void Reset()
    {
        m_currentTime = 0f;
        hasStopped = false;
    }

    public override string ToString()
    {
        return m_currentTime.ToString();
    }

    // :: Private Methods ::

    private bool UpdateAndCheck()
    {
        if (hasStopped) { return true; }
        // - 
        float dt = UseUnscaledTime ? Time.unscaledDeltaTime : Time.deltaTime;
        m_currentTime = Mathf.MoveTowards(m_currentTime, m_timeAmount, dt);
        if (System.Math.Abs(m_currentTime - m_timeAmount) < float.Epsilon)
        {
            hasStopped = true;
            return true;
        }
        return false;
    }

    private void ModifyTimeAmount(float newTimeAmount)
    {
        //if (Mathf.Abs(newTimeAmount) < Mathf.Abs(m_currentTime))
        //{
        //    Debug.LogWarning(ToString() + ": cannot set Time Amount lower that current time! Clamping...");
        //}
        //m_timeAmount = Mathf.Max(newTimeAmount, m_currentTime);
        m_timeAmount = newTimeAmount;
    }

    private void ModifyCurrentTime(float newCurrentTime)
    {
        m_currentTime = Mathf.Clamp(newCurrentTime, 0f, m_timeAmount);
    }

}

/* CHANGELOG
 * [apr2019] v2.0.0 fixed main bug :( Alos compatible with negative values
 * [mar2019] v1.0.0 first version
*/

    // ++ We could use this as base and inherit Timer.
    // ++ If so this should be timer and the other, TimerAdvanced