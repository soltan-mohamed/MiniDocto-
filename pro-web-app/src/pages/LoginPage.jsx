import React, { useState } from 'react'
import { Link } from 'react-router-dom'
import { authService } from '../services/api'
import './AuthPages.css'

function LoginPage({ onLogin }) {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')
    setLoading(true)

    try {
      const data = await authService.login(email, password)
      localStorage.setItem('token', data.token)
      localStorage.setItem('user', JSON.stringify(data))
      onLogin()
    } catch (err) {
      setError(err.response?.data?.message || 'Email ou mot de passe incorrect')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="auth-container">
      <div className="auth-card">
        <div className="auth-header">
          <div className="auth-icon">🏥</div>
          <h1>MiniDocto+</h1>
          <p>Espace Professionnel de Santé</p>
        </div>

        <form onSubmit={handleSubmit} className="auth-form">
          {error && (
            <div className="error-message">
              <span className="error-icon">⚠️</span>
              {error}
            </div>
          )}

          <div className="form-group">
            <label>
              <span className="label-icon">📧</span>
              Adresse Email
            </label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              placeholder="professionnel@exemple.com"
            />
          </div>

          <div className="form-group">
            <label>
              <span className="label-icon">🔒</span>
              Mot de passe
            </label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
              placeholder="••••••••"
            />
          </div>

          <button type="submit" className="submit-btn" disabled={loading}>
            {loading ? (
              <>
                <span className="spinner"></span>
                Connexion en cours...
              </>
            ) : (
              <>
                <span>✨</span>
                Se connecter
              </>
            )}
          </button>
        </form>

        <div className="auth-footer">
          <p>
            Nouveau sur MiniDocto+ ?{' '}
            <Link to="/register">🚀 Créer un compte</Link>
          </p>
        </div>
      </div>
    </div>
  )
}

export default LoginPage
