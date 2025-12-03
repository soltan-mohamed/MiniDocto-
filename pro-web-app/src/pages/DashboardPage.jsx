import React, { useState, useEffect } from 'react'
import { appointmentService, timeSlotService } from '../services/api'
import './DashboardPage.css'

function DashboardPage() {
  const [stats, setStats] = useState({
    totalAppointments: 0,
    confirmedAppointments: 0,
    totalSlots: 0,
    availableSlots: 0,
  })
  const [loading, setLoading] = useState(true)
  const [user, setUser] = useState(null)

  useEffect(() => {
    loadDashboardData()
    const userData = localStorage.getItem('user')
    if (userData) {
      setUser(JSON.parse(userData))
    }
  }, [])

  const loadDashboardData = async () => {
    try {
      const [appointments, slots] = await Promise.all([
        appointmentService.getProfessionalAppointments(),
        timeSlotService.getMySlots(),
      ])

      setStats({
        totalAppointments: appointments.length,
        confirmedAppointments: appointments.filter(
          (a) => a.status === 'CONFIRMED'
        ).length,
        totalSlots: slots.length,
        availableSlots: slots.filter((s) => s.available).length,
      })
    } catch (error) {
      console.error('Erreur lors du chargement des données:', error)
    } finally {
      setLoading(false)
    }
  }

  if (loading) {
    return <div className="loading">Chargement...</div>
  }

  return (
    <div className="dashboard">
      <div className="dashboard-header">
        <h1>Tableau de bord</h1>
        {user && (
          <p>
            Bienvenue, {user.firstName} {user.lastName}
          </p>
        )}
      </div>

      <div className="stats-grid">
        <div className="stat-card">
          <div className="stat-icon">📅</div>
          <div className="stat-content">
            <h3>{stats.totalAppointments}</h3>
            <p>Rendez-vous total</p>
          </div>
        </div>

        <div className="stat-card">
          <div className="stat-icon">✅</div>
          <div className="stat-content">
            <h3>{stats.confirmedAppointments}</h3>
            <p>Rendez-vous confirmés</p>
          </div>
        </div>

        <div className="stat-card">
          <div className="stat-icon">🕐</div>
          <div className="stat-content">
            <h3>{stats.totalSlots}</h3>
            <p>Créneaux total</p>
          </div>
        </div>

        <div className="stat-card">
          <div className="stat-icon">🆓</div>
          <div className="stat-content">
            <h3>{stats.availableSlots}</h3>
            <p>Créneaux disponibles</p>
          </div>
        </div>
      </div>

      <div className="dashboard-info">
        <div className="info-card">
          <h2>Bienvenue sur votre espace professionnel</h2>
          <p>
            Gérez vos créneaux de disponibilité et consultez vos rendez-vous
            avec vos patients en toute simplicité.
          </p>
          <ul>
            <li>✨ Créez et gérez vos créneaux horaires</li>
            <li>📋 Consultez la liste de vos rendez-vous</li>
            <li>👥 Suivez vos patients</li>
          </ul>
        </div>
      </div>
    </div>
  )
}

export default DashboardPage
