import request from '../utils/request'

export function loginApi(data) {
  return request({
    url: '/api/auth/login',
    method: 'post',
    data,
  })
}

export function currentApi() {
  return request({
    url: '/api/auth/current',
    method: 'get',
  })
}

export function changePasswordApi(data) {
  return request({
    url: '/api/auth/change-password',
    method: 'post',
    data,
  })
}
