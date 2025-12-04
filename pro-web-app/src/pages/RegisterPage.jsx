import React, { useState } from 'react'
import { Link } from 'react-router-dom'
import { authService } from '../services/api'
import analytics from '../services/analytics'
import './AuthPages.css'

function RegisterPage({ onRegister }) {
  const [formData, setFormData] = useState({
    email: '',
    password: '',
    firstName: '',
    lastName: '',
    phone: '',
    speciality: '',
    description: '',
    address: '',
  })
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value,
    })
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')
    setLoading(true)

    try {
      const data = await authService.register({
        ...formData,
        role: 'PROFESSIONAL',
      })
      localStorage.setItem('token', data.token)
      localStorage.setItem('user', JSON.stringify(data))
      
      // Track sign up event
      analytics.logSignUp('email')
      
      onRegister()
    } catch (err) {
      setError(err.response?.data?.message || 'Erreur lors de l\'inscription')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="auth-container">
      <div className="auth-card register-card">
        <div className="auth-header">
          <div className="auth-icon">🩺</div>
          <h1>Rejoignez MiniDocto+</h1>
          <p>Créez votre profil professionnel en quelques clics</p>
        </div>

        <form onSubmit={handleSubmit} className="auth-form">
          {error && (
            <div className="error-message">
              <span className="error-icon">⚠️</span>
              {error}
            </div>
          )}

          <div className="form-row">
            <div className="form-group">
              <label>
                <span className="label-icon">👤</span>
                Prénom *
              </label>
              <input
                type="text"
                name="firstName"
                value={formData.firstName}
                onChange={handleChange}
                required
                placeholder="Mohamed"
              />
            </div>

            <div className="form-group">
              <label>
                <span className="label-icon">👤</span>
                Nom *
              </label>
              <input
                type="text"
                name="lastName"
                value={formData.lastName}
                onChange={handleChange}
                required
                placeholder="Soltan"
              />
            </div>
          </div>

          <div className="form-group">
            <label>
              <span className="label-icon">📧</span>
              Email *
            </label>
            <input
              type="email"
              name="email"
              value={formData.email}
              onChange={handleChange}
              required
              placeholder="professionnel@gmail.com"
            />
          </div>

          <div className="form-group">
            <label>
              <span className="label-icon">📱</span>
              Téléphone *
            </label>
            <input
              type="tel"
              name="phone"
              value={formData.phone}
              onChange={handleChange}
              required
              placeholder="+216 XX XXX XXX"
            />
          </div>

          <div className="form-group">
            <label>
              <span className="label-icon">🩺</span>
              Spécialité *
            </label>
            <input
              type="text"
              name="speciality"
              value={formData.speciality}
              onChange={handleChange}
              placeholder="Ex: Cardiologue, Dentiste, Pédiatre..."
              required
            />
          </div>

          <div className="form-group">
            <label>
              <span className="label-icon">📍</span>
              Adresse du cabinet *
            </label>
            <input
              type="text"
              name="address"
              value={formData.address}
              onChange={handleChange}
              required
              placeholder="2088 Avenue de la Santé, Tunis"
            />
          </div>

          <div className="form-group">
            <label>
              <span className="label-icon">✍️</span>
              Description professionnelle
            </label>
            <textarea
              name="description"
              value={formData.description}
              onChange={handleChange}
              rows="3"
              placeholder="Présentez votre expérience, vos compétences et votre approche médicale..."
            />
          </div>

          <div className="form-group">
            <label>
              <span className="label-icon">🔒</span>
              Mot de passe *
            </label>
            <input
              type="password"
              name="password"
              value={formData.password}
              onChange={handleChange}
              required
              minLength="6"
              placeholder="Minimum 6 caractères"
            />
          </div>

          <button type="submit" className="submit-btn" disabled={loading}>
            {loading ? (
              <>
                <span className="spinner"></span>
                Création du compte...
              </>
            ) : (
              <>
                <span>🚀</span>
                Créer mon compte professionnel
              </>
            )}
          </button>
        </form>

        <div className="auth-footer">
          <p>
            Déjà inscrit ?{' '}
            <Link to="/login">✨ Se connecter</Link>
          </p>
        </div>
      </div>
    </div>
  )
}

export default RegisterPage
