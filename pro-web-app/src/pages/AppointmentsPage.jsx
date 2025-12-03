import React, { useState, useEffect } from 'react'
import { appointmentService } from '../services/api'
import { format } from 'date-fns'
import { fr } from 'date-fns/locale'
import './AppointmentsPage.css'

function AppointmentsPage() {
  const [appointments, setAppointments] = useState([])
  const [loading, setLoading] = useState(true)
  const [filter, setFilter] = useState('ALL')

  useEffect(() => {
    loadAppointments()
  }, [])

  const loadAppointments = async () => {
    try {
      const data = await appointmentService.getProfessionalAppointments()
      setAppointments(data)
    } catch (error) {
      console.error('Erreur lors du chargement des rendez-vous:', error)
    } finally {
      setLoading(false)
    }
  }

  const getStatusBadge = (status) => {
    const badges = {
      CONFIRMED: { label: 'Confirmé', color: '#2ecc71' },
      PENDING: { label: 'En attente', color: '#f39c12' },
      CANCELLED: { label: 'Annulé', color: '#e74c3c' },
      COMPLETED: { label: 'Terminé', color: '#3498db' },
    }
    return badges[status] || { label: status, color: '#95a5a6' }
  }

  const filteredAppointments = appointments.filter((apt) => {
    if (filter === 'ALL') return true
    return apt.status === filter
  })

  if (loading) {
    return <div className="loading">Chargement...</div>
  }

  return (
    <div className="appointments-page">
      <div className="page-header">
        <h1>Mes rendez-vous</h1>
        <div className="filter-buttons">
          <button
            className={filter === 'ALL' ? 'active' : ''}
            onClick={() => setFilter('ALL')}
          >
            Tous ({appointments.length})
          </button>
          <button
            className={filter === 'CONFIRMED' ? 'active' : ''}
            onClick={() => setFilter('CONFIRMED')}
          >
            Confirmés (
            {appointments.filter((a) => a.status === 'CONFIRMED').length})
          </button>
          <button
            className={filter === 'PENDING' ? 'active' : ''}
            onClick={() => setFilter('PENDING')}
          >
            En attente (
            {appointments.filter((a) => a.status === 'PENDING').length})
          </button>
        </div>
      </div>

      {filteredAppointments.length === 0 ? (
        <div className="empty-state">
          <p>Aucun rendez-vous trouvé</p>
        </div>
      ) : (
        <div className="appointments-list">
          {filteredAppointments.map((appointment) => {
            const statusInfo = getStatusBadge(appointment.status)
            return (
              <div key={appointment.id} className="appointment-card">
                <div className="appointment-header">
                  <div className="patient-info">
                    <div className="patient-avatar">
                      {appointment.patientName?.charAt(0) || '👤'}
                    </div>
                    <div>
                      <h3>{appointment.patientName || 'Patient'}</h3>
                      <span
                        className="status-badge"
                        style={{ backgroundColor: statusInfo.color }}
                      >
                        {statusInfo.label}
                      </span>
                    </div>
                  </div>
                  <div className="appointment-datetime">
                    <div className="date">
                      📅{' '}
                      {format(
                        new Date(appointment.appointmentTime),
                        'EEEE d MMMM yyyy',
                        { locale: fr }
                      )}
                    </div>
                    <div className="time">
                      🕐{' '}
                      {format(new Date(appointment.appointmentTime), 'HH:mm')}
                    </div>
                  </div>
                </div>

                {appointment.reason && (
                  <div className="appointment-reason">
                    <strong>Motif :</strong> {appointment.reason}
                  </div>
                )}

                {appointment.notes && (
                  <div className="appointment-notes">
                    <strong>Notes :</strong> {appointment.notes}
                  </div>
                )}
              </div>
            )
          })}
        </div>
      )}
    </div>
  )
}

export default AppointmentsPage
