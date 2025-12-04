import axios from 'axios'

const API_BASE_URL = 'http://localhost:8080/api'

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
})

api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

export const authService = {
  register: async (data) => {
    const response = await api.post('/auth/register', data)
    return response.data
  },

  login: async (email, password) => {
    const response = await api.post('/auth/login', { email, password })
    return response.data
  },
}

export const timeSlotService = {
  getMySlots: async () => {
    const response = await api.get('/timeslots/my-slots')
    return response.data
  },

  createSlot: async (data) => {
    const response = await api.post('/timeslots', data)
    return response.data
  },

  deleteSlot: async (slotId) => {
    await api.delete(`/timeslots/${slotId}`)
  },
}

export const appointmentService = {
  getProfessionalAppointments: async () => {
    const response = await api.get('/appointments/professional')
    return response.data
  },
}

export const userService = {
  getProfile: async () => {
    const response = await api.get('/auth/me')
    return response.data
  },
}

export default api
