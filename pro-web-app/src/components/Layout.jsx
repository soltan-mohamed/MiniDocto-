import React from 'react'
import { Link, useLocation } from 'react-router-dom'
import './Layout.css'

function Layout({ children, onLogout }) {
  const location = useLocation()

  const isActive = (path) => location.pathname === path

  return (
    <div className="layout">
      <nav className="sidebar">
        <div className="sidebar-header">
          <h2>Mini-Docto Plus</h2>
          <p>Espace Professionnel</p>
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
