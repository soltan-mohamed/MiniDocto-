import React, { useState, useEffect } from 'react'
import { timeSlotService } from '../services/api'
import { format } from 'date-fns'
import { fr } from 'date-fns/locale'
import './TimeSlotsPage.css'

function TimeSlotsPage() {
  const [slots, setSlots] = useState([])
  const [loading, setLoading] = useState(true)
  const [showModal, setShowModal] = useState(false)
  const [formData, setFormData] = useState({
    startTime: '',
    endTime: '',
  })

  useEffect(() => {
    loadSlots()
  }, [])

  const loadSlots = async () => {
    try {
      const data = await timeSlotService.getMySlots()
      setSlots(data)
    } catch (error) {
      console.error('Erreur lors du chargement des créneaux:', error)
    } finally {
      setLoading(false)
    }
  }

  const handleCreateSlot = async (e) => {
    e.preventDefault()
    try {
      await timeSlotService.createSlot(formData)
      setShowModal(false)
      setFormData({ startTime: '', endTime: '' })
      loadSlots()
    } catch (error) {
      alert('Erreur lors de la création du créneau')
    }
  }

  const handleDeleteSlot = async (slotId) => {
    if (window.confirm('Êtes-vous sûr de vouloir supprimer ce créneau ?')) {
      try {
        await timeSlotService.deleteSlot(slotId)
        loadSlots()
      } catch (error) {
        alert('Erreur lors de la suppression du créneau')
      }
    }
  }

  const formatDateTime = (dateString) => {
    const date = new Date(dateString)
    return format(date, "EEEE d MMMM yyyy 'à' HH:mm", { locale: fr })
  }

  if (loading) {
    return <div className="loading">Chargement...</div>
  }

  return (
    <div className="timeslots-page">
      <div className="page-header">
        <h1>Mes créneaux horaires</h1>
        <button className="btn-primary" onClick={() => setShowModal(true)}>
          ➕ Ajouter un créneau
        </button>
      </div>

      {slots.length === 0 ? (
        <div className="empty-state">
          <p>Aucun créneau créé</p>
          <button className="btn-primary" onClick={() => setShowModal(true)}>
            Créer mon premier créneau
          </button>
        </div>
      ) : (
        <div className="slots-grid">
          {slots.map((slot) => (
            <div
              key={slot.id}
              className={`slot-card ${slot.available ? 'available' : 'booked'}`}
            >
              <div className="slot-status">
                {slot.available ? '🟢 Disponible' : '🔴 Réservé'}
              </div>
              <div className="slot-info">
                <p className="slot-date">
                  {formatDateTime(slot.startTime)}
                </p>
                <p className="slot-time">
                  {format(new Date(slot.startTime), 'HH:mm')} -{' '}
                  {format(new Date(slot.endTime), 'HH:mm')}
                </p>
              </div>
              {slot.available && (
                <button
                  className="btn-delete"
                  onClick={() => handleDeleteSlot(slot.id)}
                >
                  🗑️ Supprimer
                </button>
              )}
            </div>
          ))}
        </div>
      )}

      {showModal && (
        <div className="modal-overlay" onClick={() => setShowModal(false)}>
          <div className="modal" onClick={(e) => e.stopPropagation()}>
            <h2>Nouveau créneau</h2>
            <form onSubmit={handleCreateSlot}>
              <div className="form-group">
                <label>Date et heure de début</label>
                <input
                  type="datetime-local"
                  value={formData.startTime}
                  onChange={(e) =>
                    setFormData({ ...formData, startTime: e.target.value })
                  }
                  required
                />
              </div>
              <div className="form-group">
                <label>Date et heure de fin</label>
                <input
                  type="datetime-local"
                  value={formData.endTime}
                  onChange={(e) =>
                    setFormData({ ...formData, endTime: e.target.value })
                  }
                  required
                />
              </div>
              <div className="modal-actions">
                <button
                  type="button"
                  className="btn-secondary"
                  onClick={() => setShowModal(false)}
                >
                  Annuler
                </button>
                <button type="submit" className="btn-primary">
                  Créer
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  )
}

export default TimeSlotsPage
