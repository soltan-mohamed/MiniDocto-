import React from 'react'
import './StatsChart.css'

function StatsChart({ stats }) {
  const maxValue = Math.max(
    stats.totalAppointments,
    stats.confirmedAppointments,
    stats.totalSlots,
    stats.availableSlots,
    stats.unavailableSlots,
    1
  )

  const chartData = [
    {
      label: 'Rendez-vous total',
      value: stats.totalAppointments,
      color: '#4CAF50',
      icon: '📅'
    },
    {
      label: 'RDV confirmés',
      value: stats.confirmedAppointments,
      color: '#2196F3',
      icon: '✅'
    },
    {
      label: 'Créneaux total',
      value: stats.totalSlots,
      color: '#FF9800',
      icon: '🕐'
    },
    {
      label: 'Créneaux disponibles',
      value: stats.availableSlots,
      color: '#8BC34A',
      icon: '🆓'
    },
    {
      label: 'Créneaux indisponibles',
      value: stats.unavailableSlots,
      color: '#F44336',
      icon: '🚫'
    }
  ]

  return (
    <div className="stats-chart">
      <h2 className="chart-title">📊 Statistiques détaillées</h2>
      <div className="chart-container">
        {chartData.map((item, index) => {
          const percentage = maxValue > 0 ? (item.value / maxValue) * 100 : 0
          
          return (
            <div key={index} className="chart-row">
              <div className="chart-label">
                <span className="chart-icon">{item.icon}</span>
                <span className="chart-text">{item.label}</span>
              </div>
              <div className="chart-bar-container">
                <div 
                  className="chart-bar"
                  style={{
                    width: `${percentage}%`,
                    backgroundColor: item.color
                  }}
                >
                  <span className="chart-value">{item.value}</span>
                </div>
              </div>
            </div>
          )
        })}
      </div>


      <div className="chart-summary">
        <div className="summary-item">
          <span className="summary-label">Taux de confirmation</span>
          <span className="summary-value">
            {stats.totalAppointments > 0 
              ? Math.round((stats.confirmedAppointments / stats.totalAppointments) * 100)
              : 0}%
          </span>
        </div>
        <div className="summary-item">
          <span className="summary-label">Taux de disponibilité</span>
          <span className="summary-value">
            {stats.totalSlots > 0 
              ? Math.round((stats.availableSlots / stats.totalSlots) * 100)
              : 0}%
          </span>
        </div>
        <div className="summary-item">
          <span className="summary-label">Créneaux utilisés</span>
          <span className="summary-value">
            {stats.totalSlots > 0 
              ? Math.round((stats.unavailableSlots / stats.totalSlots) * 100)
              : 0}%
          </span>
        </div>
      </div>
    </div>
  )
}

export default StatsChart
