using System;
using UnityEngine;

// ANDRES MALDONADO - IKI

// [apr2019] v3.1.3 Remove ReadOnly from current Time
// [feb2019] v3.1.2 Loop counter, some Summaries fixes, countdown half-fixed
// [feb2019] v3.0.0 Lots of changes, IKI version is mostly gone.
// [04.07.18] v2.1.1 + Serializable class and test variables
// [04.07.18] v?.?.? + Refactoring, DeltaType, little fixes


/// <summary>
/// Creates a simple to use timer that ca be set up on the inspector (public)
/// and also reusable via script.
/// </summary>
[System.Serializable]
public class Timer
{
    // ++ Add GetFormatedTime() return a string 

    //:: External Settings
    [Tooltip("In seconds, the time to reach / count from")]
    [SerializeField]
    private float m_timeAmount = 30f;
    [SerializeField]
    private float m_currentTime;
    [Tooltip("If enabled, the timer begins from Time Amount and decreases to zero")]
    [SerializeField]
    private bool m_isCountdown;
    [Tooltip("Make the timer loop after reaching the end")]
    [SerializeField]
    private bool m_loop;
    private int _loopsCounter;
    [Tooltip("Type of deltaTime in which this instance runs")]
    [SerializeField]
    private DeltaTimeType m_deltaTimeType = DeltaTimeType.normalTime;

    private bool isPlaying = true; // Is the timer on play?
    private bool hasEnded;

    #region Properties
    /// <summary>
    /// Moves this <see cref="T:Timer"/> then returns the current time.
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
        get { VerifyCountdown(); return m_currentTime; }
    }

    /// <summary>
    /// Amount of time in this timer. Not modifiable below <see cref="CurrentTime"/>.
    /// </summary>
    public float TimeAmount
    {
        set { ModifyTimeAmount(value); }
        get { return m_timeAmount; }
    }

    /// <summary>
    /// If true, the timer automatically loops after it finishes.
    /// </summary>
    /// <value><c>true</c> if it can loop; otherwise, <c>false</c>.</value>
    public bool Loop
    {
        get { return m_loop; }
        set { m_loop = value; }
    }

    /// <summary>
    /// The times this timer has looped, <see cref="Loop"/> must be activated.
    /// </summary>
    public int LoopsCounter
    {
        get { return _loopsCounter; }
    }

    /// <summary>
    /// Gets or sets the type of the delta time used by this <see cref="T:Timer"/>.
    /// </summary>
    /// <value>The type of the delta time.</value>
    public DeltaTimeType DeltaTimeType
    {
        get { return m_deltaTimeType; }
        set { m_deltaTimeType = value; }
    }

    /// <summary>
    /// Gets the normalized (0 to 1) value of the timer.
    /// This does NOT move the <see cref="T:Timer"/>
    /// </summary>
    public float NormalizedFixed
    {
        get
        {
            VerifyCountdown();
            return m_isCountdown ? (m_timeAmount - m_currentTime) / m_timeAmount : m_currentTime / m_timeAmount;
        }
    }

    /// <summary>
    /// Moves this <see cref="T:Timer"/> then 
    /// returns the normalized (0 to 1) value of the timer.
    /// <para></para>
    /// This can be passed to an easing or lerp function to get desired motions.
    /// </summary>
    public float Normalized
    {
        get
        {
            UpdateAndCheck();
            return m_isCountdown ? (m_timeAmount - m_currentTime) / m_timeAmount : m_currentTime / m_timeAmount;
        }
    }

    /// <summary>
    /// Moves this <see cref="T:Timer"/> then 
    /// returns whether or not this <see cref="T:Timer"/> is over (or has looped
    /// if <see cref="Loop"/> is enabled).
    /// </summary>
    /// <value><c>true</c> if is over; otherwise, <c>false</c>.</value>
    public bool Check
    {
        get { return UpdateAndCheck(); }
    }

    /// <summary>
    /// Gets a value indicating whether this <see cref="T:Timer"/> has ended.
    /// This does NOT move the timer.
    /// </summary>
    /// <value><c>true</c> if has ended; otherwise, <c>false</c>.</value>
    public bool HasEnded
    {
        get { return hasEnded; }
    }

    #endregion

    // ==================

    #region Constructors
    public Timer()
    {
        if (m_isCountdown) { m_currentTime = m_timeAmount; }
    }

    /// <summary>
    /// Sets a Timer that goes from timeAmount to zero by default.
    /// Optionally, we can auto loop the timer or start from timeAmount to zero.
    /// </summary>
    /// <param name="timeAmount">Time to reach or count from</param>
    /// <param name="countdown">Make this timer descend to zero</param>
    /// <param name="loop">Reapeat after timer is done</param>
    public Timer(float timeAmount, bool countdown = false, bool loop = false, DeltaTimeType timeType = DeltaTimeType.normalTime)
    {
        m_timeAmount = timeAmount;
        m_isCountdown = countdown;
        m_loop = loop;
        m_deltaTimeType = timeType;
        _loopsCounter = 0;

        if (countdown) { m_currentTime = m_timeAmount; }
    }
    /// <summary>
    /// Sets a Timer that goes from zero to the specified time.
    /// </summary>
    /// <param name="seconds">Values over 60 are accepted</param>
    /// <param name="minutes"></param>
    public Timer(float seconds, float minutes = 0f)
    {
        seconds += minutes * 60f;
        m_timeAmount = seconds;
        m_isCountdown = false;
        m_loop = false;
        m_deltaTimeType = DeltaTimeType.normalTime;
        _loopsCounter = 0;
    }

    #endregion

    /// <summary>
    /// Same as <see cref="Check"/>.
    /// <para>This makes the timer move</para>
    /// </summary>
    public bool UpdateAndCheck()
    {
        VerifyCountdown();
        if (hasEnded & !m_loop) { return true; }
        if (!isPlaying) { return false; }
        //
        float dt = GetDeltaTime();

        // TODO: Pretty sure there's a way to get rid of one: if(m_loop)
        if (m_isCountdown) // If it's a countdown
        {
            m_currentTime -= dt; // We subtract the time of the current frame
            if (m_currentTime <= 0f) // If the time is up
            {
                if (m_loop) // If we're looping
                {
                    m_currentTime += m_timeAmount; // Reset the timer for the next loop
                    _loopsCounter++;
                }
                else
                {
                    hasEnded = true; // The timer has ended and stoped
                }
                return true; // Timer is done in this frame
            }
        }
        else
        {
            m_currentTime += dt; // We add the time of the current frame
            if (m_currentTime >= m_timeAmount) // If the time is up
            {
                if (m_loop) // If we're looping
                {
                    m_currentTime -= m_timeAmount; // Reset the timer for the next loop
                    _loopsCounter++;
                }
                else
                {
                    hasEnded = true; // The timer has ended and stoped
                }
                return true; // Timer is done in this frame
            }
        }
        return false; // It's not done
    }

    [HideInInspector]
    bool runOnce = true;
    private void VerifyCountdown()
    {
        if (runOnce)
        {
            if (m_isCountdown) { m_currentTime = m_timeAmount; }
            runOnce = false;
        }
    }

    /// <summary>
    /// Resets the timer to its construction values.
    /// </summary>
    public void Reset()
    {
        m_currentTime = m_isCountdown ? m_timeAmount : 0.0f;
        hasEnded = false;
        _loopsCounter = 0;
    }
    /// <summary>
    /// Resumes this timer if paused.
    /// </summary>
    public void Play()
    {
        isPlaying = true;
    }
    /// <summary>
    /// Pauses the timer, use <see cref="Play"/> to resume it.
    /// </summary>
    public void Pause()
    {
        isPlaying = false;
    }
    /// <summary>
    /// Scales this timer. Only positive values are accepted.
    /// </summary>
    public void ScaleTimer(float scale)
    {
        scale = Mathf.Abs(scale);
        m_currentTime *= scale;
        m_timeAmount *= scale;
    }

    /// <summary>
    /// The percentage of timer done-ness, normalized (from 0f to 1f).
    /// </summary>
    [Obsolete("Use Timer.NormalizedFixed property instead")]
    public float TimePercentage()
    {
        float percentage;
        if (m_isCountdown)
            percentage = (m_timeAmount - m_currentTime) / m_timeAmount;
        else
            percentage = m_currentTime / m_timeAmount;
        percentage = Mathf.Clamp(percentage, 0f, 1f);
        return percentage;
    }

    private void ModifyTimeAmount(float newTimeAmount)
    {
        if (newTimeAmount < m_currentTime)
        {
            Debug.LogWarning(ToString() + ": cannot set Time Amount lower that current time! Clamping...");
        }
        m_timeAmount = Mathf.Max(newTimeAmount, m_currentTime);
    }

    private void ModifyCurrentTime(float newCurrentTime)
    {
        m_currentTime = Mathf.Clamp(newCurrentTime, 0f, m_timeAmount);
    }

    private float GetDeltaTime()
    {
        switch (m_deltaTimeType)
        {
            case DeltaTimeType.normalTime:
                return Time.deltaTime;
            case DeltaTimeType.unscaledTime:
                return Time.unscaledDeltaTime;
            case DeltaTimeType.smoothTime:
                return Time.smoothDeltaTime;
            case DeltaTimeType.fixedTime:
                return Time.fixedDeltaTime;
            default:
                return 0f;
        }
    }
}

/// <summary>
/// Type of deltaType to be used
/// </summary>
public enum DeltaTimeType
{
    /// <summary>
    /// Common Time.deltaTime affected by timeScale
    /// </summary>
    normalTime,
    /// <summary>
    /// unscaledDeltaTime not affected by timeScale
    /// </summary>
    unscaledTime,
    /// <summary>
    /// Time.smoothDeltaTime affected by timeScale
    /// </summary>
    smoothTime,
    /// <summary>
    /// Time.fixedDeltaTime for use in FixedUpdate
    /// </summary>
    fixedTime,
}
