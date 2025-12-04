import React, { useState, useEffect } from 'react'
import { Link, useLocation } from 'react-router-dom'
import { userService } from '../services/api'
import './Layout.css'

function Layout({ children, onLogout }) {
  const location = useLocation()
  const [user, setUser] = useState(null)

  useEffect(() => {
    const userData = localStorage.getItem('user')
    if (userData) {
      const parsedUser = JSON.parse(userData)
      console.log('User data:', parsedUser)
      setUser(parsedUser)
    }
    
    const refreshProfile = async () => {
      try {
        const profile = await userService.getProfile()
        setUser(profile)
        localStorage.setItem('user', JSON.stringify(profile))
      } catch (error) {
        console.error('Erreur lors du rafraîchissement du profil:', error)
      }
    }
    
    refreshProfile()
    
    const interval = setInterval(refreshProfile, 30000)
    
    return () => clearInterval(interval)
  }, [])

  const isActive = (path) => location.pathname === path

  return (
    <div className="layout">
      <nav className="sidebar">
        <div className="sidebar-header">
          <h2>MiniDocto+</h2>
          {user && (
            <div className="user-info">
              <div className="user-avatar">
                {user.firstName?.[0]}{user.lastName?.[0]}
              </div>
              <div className="user-details">
                <p className="user-name">{user.firstName} {user.lastName}</p>
                <p className="user-role">{user.speciality || 'Professionnel de santé'}</p>
                <div className="user-score">
                  <span className="score-label">Score:</span>
                  <span className="score-value">{user.score || 0}/100</span>
                  <div className="score-bar">
                    <div 
                      className="score-fill" 
                      style={{ width: `${user.score || 0}%` }}
                    ></div>
                  </div>
                </div>
              </div>
            </div>
          )}
        </div>
        <ul className="nav-menu">
          <li>
            <Link
              to="/dashboard"
              className={isActive('/dashboard') ? 'active' : ''}
            >
              📊 Tableau de bord
            </Link>
          </li>
          <li>
            <Link
              to="/timeslots"
              className={isActive('/timeslots') ? 'active' : ''}
            >
              🕐 Mes créneaux
            </Link>
          </li>
          <li>
            <Link
              to="/appointments"
              className={isActive('/appointments') ? 'active' : ''}
            >
              📅 Rendez-vous
            </Link>
          </li>
        </ul>
        <div className="sidebar-footer">
          <button onClick={onLogout} className="logout-btn">
            🚪 Déconnexion
          </button>
        </div>
      </nav>
      <main className="main-content">
        {children}
      </main>
    </div>
  )
}

export default Layout
