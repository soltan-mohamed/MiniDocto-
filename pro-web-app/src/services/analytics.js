// Analytics service wrapper for Firebase Analytics
export const analytics = {
  // Log custom events
  logEvent: (eventName, params = {}) => {
    if (window.logAnalyticsEvent) {
      window.logAnalyticsEvent(eventName, params);
    }
  },

  // Login event
  logLogin: (method = 'email') => {
    if (window.logAnalyticsEvent) {
      window.logAnalyticsEvent('login', { method });
    }
  },

  // Sign up event
  logSignUp: (method = 'email') => {
    if (window.logAnalyticsEvent) {
      window.logAnalyticsEvent('sign_up', { method });
    }
  },

  // Appointment events
  logAppointmentCreated: (appointmentData) => {
    if (window.logAnalyticsEvent) {
      window.logAnalyticsEvent('appointment_created', {
        appointment_id: appointmentData.id,
        patient_name: appointmentData.patientName,
        date: appointmentData.date,
      });
    }
  },

  logAppointmentStatusChanged: (appointmentId, oldStatus, newStatus) => {
    if (window.logAnalyticsEvent) {
      window.logAnalyticsEvent('appointment_status_changed', {
        appointment_id: appointmentId,
        old_status: oldStatus,
        new_status: newStatus,
      });
    }
  },

  // Time slot events
  logTimeSlotCreated: (timeSlotData) => {
    if (window.logAnalyticsEvent) {
      window.logAnalyticsEvent('time_slot_created', {
        date: timeSlotData.date,
        start_time: timeSlotData.startTime,
        end_time: timeSlotData.endTime,
      });
    }
  },

  // Page view tracking
  logPageView: (pageName) => {
    if (window.logAnalyticsEvent) {
      window.logAnalyticsEvent('page_view', {
        page_name: pageName,
      });
    }
  },

  // Score update event
  logScoreUpdate: (newScore, oldScore) => {
    if (window.logAnalyticsEvent) {
      window.logAnalyticsEvent('score_updated', {
        new_score: newScore,
        old_score: oldScore,
      });
    }
  },
};

export default analytics;
