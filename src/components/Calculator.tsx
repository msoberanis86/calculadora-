import React, { useState, useCallback, useEffect } from 'react'
import { safeEvaluate, formatNumber } from '../utils/mathEvaluator'
import HistoryItem from './HistoryItem'
import { Preferences } from '@capacitor/preferences'
import '../styles/Calculator.css'

interface HistoryResult {
  id: string
  valor: number
  etiqueta: string
}

const Calculator: React.FC = () => {
  const [operacionActual, setOperacionActual] = useState<string>('')
  const [resultadoActual, setResultadoActual] = useState<string>('0')
  const [historialResultados, setHistorialResultados] = useState<HistoryResult[]>([])
  const [theme, setTheme] = useState<'dark' | 'light'>('dark')
  const [isLoaded, setIsLoaded] = useState<boolean>(false)

  // Aplicar tema al documento
  React.useEffect(() => {
    document.documentElement.setAttribute('data-theme', theme)
  }, [theme])

  // Cargar historial guardado al iniciar
  useEffect(() => {
    const loadHistory = async () => {
      try {
        const { value } = await Preferences.get({ key: 'calculadora_historial' })
        if (value) {
          const historial = JSON.parse(value)
          if (Array.isArray(historial)) {
            setHistorialResultados(historial)
          }
        }
      } catch (error) {
        console.error('Error al cargar historial:', error)
        // Fallback a localStorage si Preferences falla
        try {
          const stored = localStorage.getItem('calculadora_historial')
          if (stored) {
            const historial = JSON.parse(stored)
            if (Array.isArray(historial)) {
              setHistorialResultados(historial)
            }
          }
        } catch (e) {
          console.error('Error al cargar desde localStorage:', e)
        }
      }
      setIsLoaded(true)
    }
    loadHistory()
  }, [])

  // Guardar historial cuando cambie
  useEffect(() => {
    if (isLoaded) {
      const saveHistory = async () => {
        try {
          await Preferences.set({
            key: 'calculadora_historial',
            value: JSON.stringify(historialResultados)
          })
          // También guardar en localStorage como backup
          localStorage.setItem('calculadora_historial', JSON.stringify(historialResultados))
        } catch (error) {
          console.error('Error al guardar historial:', error)
          // Fallback a localStorage
          try {
            localStorage.setItem('calculadora_historial', JSON.stringify(historialResultados))
          } catch (e) {
            console.error('Error al guardar en localStorage:', e)
          }
        }
      }
      saveHistory()
    }
  }, [historialResultados, isLoaded])

  // Manejo del teclado
  React.useEffect(() => {
    const handleKeyPress = (e: KeyboardEvent) => {
      // Evitar cuando se está escribiendo en un input
      if (e.target instanceof HTMLInputElement || e.target instanceof HTMLTextAreaElement) {
        return
      }

      const key = e.key

      // Números
      if (key >= '0' && key <= '9') {
        setOperacionActual(prev => {
          const newOp = prev + key
          const result = safeEvaluate(newOp)
          if (result !== null) {
            setResultadoActual(formatNumber(result))
          } else {
            setResultadoActual(newOp)
          }
          return newOp
        })
        return
      }

      // Operadores
      switch (key) {
        case '+':
          if (operacionActual === '') {
            if (resultadoActual !== '0') {
              // Remover comas (separadores de miles) antes de usar el número
              const numValue = resultadoActual.replace(/,/g, '').replace(/[^\d.-]/g, '')
              setOperacionActual(numValue + '+')
            } else {
              setOperacionActual('0+')
            }
          } else {
            setOperacionActual(prev => prev + '+')
          }
          setResultadoActual('0')
          break
        case '-':
          if (operacionActual === '') {
            if (resultadoActual !== '0') {
              const numValue = resultadoActual.replace(/,/g, '').replace(/[^\d.-]/g, '')
              setOperacionActual(numValue + '-')
            } else {
              setOperacionActual('0-')
            }
          } else {
            setOperacionActual(prev => prev + '-')
          }
          setResultadoActual('0')
          break
        case '*':
          if (operacionActual === '') {
            if (resultadoActual !== '0') {
              const numValue = resultadoActual.replace(/,/g, '').replace(/[^\d.-]/g, '')
              setOperacionActual(numValue + '*')
            } else {
              setOperacionActual('0*')
            }
          } else {
            setOperacionActual(prev => prev + '*')
          }
          setResultadoActual('0')
          break
        case '/':
          e.preventDefault()
          if (operacionActual === '') {
            if (resultadoActual !== '0') {
              const numValue = resultadoActual.replace(/,/g, '').replace(/[^\d.-]/g, '')
              setOperacionActual(numValue + '/')
            } else {
              setOperacionActual('0/')
            }
          } else {
            setOperacionActual(prev => prev + '/')
          }
          setResultadoActual('0')
          break
        case '=':
        case 'Enter':
          e.preventDefault()
          if (operacionActual) {
            const result = safeEvaluate(operacionActual)
            if (result !== null) {
              const formatted = formatNumber(result)
              setResultadoActual(formatted)
              const etiqueta = `${operacionActual} =`
              const newHistoryItem: HistoryResult = {
                id: Date.now().toString() + Math.random().toString(36).substr(2, 9),
                valor: result,
                etiqueta: etiqueta
              }
              setHistorialResultados(prev => [...prev, newHistoryItem])
              setOperacionActual('')
            }
          }
          break
        case '.':
          // Solo punto para decimales (formato Guatemala)
          if (!operacionActual || !operacionActual.match(/[\d.)]+$/)) {
            setOperacionActual(prev => prev + '0.')
            setResultadoActual(prev => prev === '0' ? '0.' : prev + '.')
          } else if (!operacionActual.match(/\.\d*$/)) {
            setOperacionActual(prev => prev + '.')
            setResultadoActual(prev => prev + '.')
          }
          break
        case ',':
          // Ignorar coma del teclado (solo se usa para mostrar miles, no para entrada)
          break
        case '%':
          if (operacionActual) {
            const result = safeEvaluate(operacionActual)
            if (result !== null) {
              const percentage = result / 100
              setOperacionActual(percentage.toString())
              setResultadoActual(formatNumber(percentage))
            }
          } else if (resultadoActual !== '0') {
            // Remover comas (separadores de miles) antes de parsear
            const numValue = parseFloat(resultadoActual.replace(/,/g, '').replace(/[^\d.-]/g, ''))
            if (!isNaN(numValue)) {
              const percentage = numValue / 100
              setOperacionActual(percentage.toString())
              setResultadoActual(formatNumber(percentage))
            }
          }
          break
        case 'Backspace':
          e.preventDefault()
          if (operacionActual.length > 0) {
            const newOp = operacionActual.slice(0, -1)
            setOperacionActual(newOp)
            if (newOp === '') {
              setResultadoActual('0')
            } else {
              const result = safeEvaluate(newOp)
              if (result !== null) {
                setResultadoActual(formatNumber(result))
              } else {
                const lastChars = newOp.slice(-10)
                setResultadoActual(lastChars || '0')
              }
            }
          } else {
            setResultadoActual('0')
          }
          break
        case 'Escape':
        case 'Delete':
          e.preventDefault()
          setOperacionActual('')
          setResultadoActual('0')
          break
        case '(':
          if (operacionActual === '' || /[+\-*/]/.test(operacionActual.slice(-1))) {
            setOperacionActual(prev => prev + '(')
          } else {
            setOperacionActual(prev => prev + '*(')
          }
          break
        case ')': {
          const openCount = (operacionActual.match(/\(/g) || []).length
          const closeCount = (operacionActual.match(/\)/g) || []).length
          if (openCount > closeCount) {
            const newOp = operacionActual + ')'
            setOperacionActual(newOp)
            const result = safeEvaluate(newOp)
            if (result !== null) {
              setResultadoActual(formatNumber(result))
            }
          }
          break
        }
      }
    }

    window.addEventListener('keydown', handleKeyPress)
    return () => window.removeEventListener('keydown', handleKeyPress)
  }, [operacionActual, resultadoActual])

  const toggleTheme = useCallback(async () => {
    const newTheme = theme === 'dark' ? 'light' : 'dark'
    setTheme(newTheme)
    // Guardar preferencia de tema
    try {
      await Preferences.set({ key: 'calculadora_tema', value: newTheme })
      localStorage.setItem('calculadora_tema', newTheme)
    } catch (error) {
      localStorage.setItem('calculadora_tema', newTheme)
    }
  }, [theme])

  // Cargar tema guardado
  useEffect(() => {
    const loadTheme = async () => {
      try {
        const { value } = await Preferences.get({ key: 'calculadora_tema' })
        if (value && (value === 'dark' || value === 'light')) {
          setTheme(value)
        }
      } catch (error) {
        const stored = localStorage.getItem('calculadora_tema')
        if (stored === 'dark' || stored === 'light') {
          setTheme(stored)
        }
      }
    }
    loadTheme()
  }, [])

  const handleNumber = useCallback((num: string) => {
    setOperacionActual(prev => {
      const newOp = prev + num
      // Actualizar resultado en tiempo real
      const result = safeEvaluate(newOp)
      if (result !== null) {
        setResultadoActual(formatNumber(result))
      } else {
        setResultadoActual(newOp)
      }
      return newOp
    })
  }, [])

  const handleOperator = useCallback((op: string) => {
    if (operacionActual === '') {
      // Si no hay operación, usar el resultado actual
      if (resultadoActual !== '0') {
        // Remover comas (separadores de miles) y mantener punto decimal
        const numValue = resultadoActual.replace(/,/g, '').replace(/[^\d.-]/g, '')
        setOperacionActual(numValue + op)
      } else {
        setOperacionActual('0' + op)
      }
      setResultadoActual('0')
    } else {
      // Si ya hay operación, evaluar automáticamente antes de agregar el nuevo operador
      const result = safeEvaluate(operacionActual)
      if (result !== null) {
        const formatted = formatNumber(result)
        setResultadoActual(formatted)
        
        // Guardar en historial
        const etiqueta = `${operacionActual} =`
        const newHistoryItem: HistoryResult = {
          id: Date.now().toString() + Math.random().toString(36).substr(2, 9),
          valor: result,
          etiqueta: etiqueta
        }
        setHistorialResultados(prev => [...prev, newHistoryItem])
        
        // Continuar con el nuevo operador usando el resultado
        setOperacionActual(result.toString() + op)
        setResultadoActual('0')
      } else {
        // Si no se puede evaluar, simplemente agregar el operador
        setOperacionActual(prev => prev + op)
        setResultadoActual('0')
      }
    }
  }, [operacionActual, resultadoActual])

  const handleEquals = useCallback(() => {
    if (!operacionActual) return

    const result = safeEvaluate(operacionActual)
    if (result !== null) {
      const formatted = formatNumber(result)
      setResultadoActual(formatted)
      
      // Crear etiqueta para el historial
      const etiqueta = `${operacionActual} =`
      const newHistoryItem: HistoryResult = {
        id: Date.now().toString() + Math.random().toString(36).substr(2, 9),
        valor: result,
        etiqueta: etiqueta
      }
      
      setHistorialResultados(prev => [...prev, newHistoryItem])
      setOperacionActual('')
    }
  }, [operacionActual])

  const handleClear = useCallback(() => {
    setOperacionActual('')
    setResultadoActual('0')
    // Mantener historialResultados intacto
  }, [])

  const handleDelete = useCallback(() => {
    
    
    if (operacionActual.length > 0) {
      const newOp = operacionActual.slice(0, -1)
      setOperacionActual(newOp)
      if (newOp === '') {
        setResultadoActual('0')
      } else {
        const result = safeEvaluate(newOp)
        if (result !== null) {
          setResultadoActual(formatNumber(result))
        } else {
          // Si no se puede evaluar, mostrar los últimos caracteres
          const lastChars = newOp.slice(-10)
          setResultadoActual(lastChars || '0')
        }
      }
    } else if (resultadoActual !== '0') {
      // Si no hay operación pero hay un resultado, limpiar el resultado
      setResultadoActual('0')
    }
  }, [operacionActual, resultadoActual])

  const handleHistorySelect = useCallback((id: string) => {
    const item = historialResultados.find(h => h.id === id)
    if (item) {
      // Insertar el valor en la operación actual
      const valueStr = item.valor.toString()
      setOperacionActual(prev => prev + valueStr)
      setResultadoActual(formatNumber(item.valor))
      
      // Eliminar inmediatamente del historial
      setHistorialResultados(prev => prev.filter(h => h.id !== id))
    }
  }, [historialResultados])

  // Función de deshacer (mantenida para futuras implementaciones)
  // const handleUndo = useCallback(() => {
  //   if (undoState) {
  //     // Restaurar estado anterior
  //     setOperacionActual(undoState.operacionActual)
  //     setResultadoActual(undoState.resultadoActual)
  //     
  //     // Restaurar la ficha del historial si existe
  //     if (undoState.historialItem) {
  //       setHistorialResultados(prev => [...prev, undoState.historialItem!])
  //     }
  //     
  //     // Limpiar estado de deshacer
  //   }
  // }, [undoState])

  const handleDecimal = useCallback(() => {
    
    if (!operacionActual || !operacionActual.match(/[\d.)]+$/)) {
      setOperacionActual(prev => prev + '0.')
      setResultadoActual(prev => prev === '0' ? '0.' : prev + '.')
    } else if (!operacionActual.match(/\.\d*$/)) {
      setOperacionActual(prev => prev + '.')
      setResultadoActual(prev => prev + '.')
    }
  }, [operacionActual])

  const handleParenthesis = useCallback((paren: '(' | ')') => {
    
    
    if (paren === '(') {
      // Abrir paréntesis: agregar después de un operador o al inicio
      if (operacionActual === '' || /[+\-*/]/.test(operacionActual.slice(-1))) {
        setOperacionActual(prev => prev + '(')
      } else {
        // Si hay un número antes, agregar operador de multiplicación implícita
        setOperacionActual(prev => prev + '*(')
      }
    } else {
      // Cerrar paréntesis: solo si hay paréntesis abiertos
      const openCount = (operacionActual.match(/\(/g) || []).length
      const closeCount = (operacionActual.match(/\)/g) || []).length
      
      if (openCount > closeCount) {
        setOperacionActual(prev => prev + ')')
        // Evaluar en tiempo real si es posible
        const result = safeEvaluate(operacionActual + ')')
        if (result !== null) {
          setResultadoActual(formatNumber(result))
        }
      }
    }
  }, [operacionActual])

  const handlePercentage = useCallback(() => {
    
    
    if (operacionActual) {
      // Si hay una operación completa, calcular el porcentaje del resultado
      const result = safeEvaluate(operacionActual)
      if (result !== null) {
        const percentage = result / 100
        const newOp = percentage.toString()
        setOperacionActual(newOp)
        setResultadoActual(formatNumber(percentage))
      }
    } else if (resultadoActual !== '0') {
      // Si solo hay un número en pantalla, calcular su porcentaje
      // Remover comas (separadores de miles) antes de parsear
      const numValue = parseFloat(resultadoActual.replace(/,/g, '').replace(/[^\d.-]/g, ''))
      if (!isNaN(numValue)) {
        const percentage = numValue / 100
        const percentageStr = percentage.toString()
        setOperacionActual(percentageStr)
        setResultadoActual(formatNumber(percentage))
      }
    } else {
      // Si está en cero, no hacer nada
      return
    }
  }, [operacionActual, resultadoActual])

  return (
    <div className="calculator-container">
      <div className="calculator">
        {/* Toggle de tema */}
        <div className="theme-toggle-container">
          <button 
            className="theme-toggle" 
            onClick={toggleTheme}
            aria-label={`Cambiar a tema ${theme === 'dark' ? 'claro' : 'oscuro'}`}
            title={`Cambiar a tema ${theme === 'dark' ? 'claro' : 'oscuro'}`}
          >
            {theme === 'dark' ? '☀️' : '🌙'}
          </button>
        </div>

        {/* Pantalla */}
        <div className="display">
          <div className="display-header">
            <button 
              className={`btn-clear-display ${theme === 'dark' ? 'btn-clear-dark' : 'btn-clear-light'}`}
              onClick={handleClear} 
              aria-label="Borrar todo"
              title="Borrar todo (Escape o Delete)"
            >
              ×
            </button>
          </div>
          <div className="operation">{operacionActual || ' '}</div>
          <div className="result">{resultadoActual}</div>
          
          {/* Historial debajo del resultado */}
          {historialResultados.length > 0 && (
            <div className="history-below-result">
              <div className="history-scroll">
                {historialResultados.map(item => (
                  <HistoryItem
                    key={item.id}
                    id={item.id}
                    valor={item.valor}
                    etiqueta={item.etiqueta}
                    onSelect={handleHistorySelect}
                  />
                ))}
              </div>
            </div>
          )}
        </div>

        {/* Botonera */}
        <div className="button-grid">
          {/* Números a la izquierda, Operadores a la derecha */}
          
          {/* Primera fila: 7, 8, 9 | ÷, × */}
          <button className="btn btn-number" onClick={() => handleNumber('7')}>7</button>
          <button className="btn btn-number" onClick={() => handleNumber('8')}>8</button>
          <button className="btn btn-number" onClick={() => handleNumber('9')}>9</button>
          <button className="btn btn-operator" onClick={() => handleOperator('/')} aria-label="Dividir">
            ÷
          </button>
          <button className="btn btn-operator" onClick={() => handleOperator('*')} aria-label="Multiplicar">
            ×
          </button>

          {/* Segunda fila: 4, 5, 6 | −, + */}
          <button className="btn btn-number" onClick={() => handleNumber('4')}>4</button>
          <button className="btn btn-number" onClick={() => handleNumber('5')}>5</button>
          <button className="btn btn-number" onClick={() => handleNumber('6')}>6</button>
          <button className="btn btn-operator" onClick={() => handleOperator('-')} aria-label="Restar">
            −
          </button>
          <button className="btn btn-operator" onClick={() => handleOperator('+')} aria-label="Sumar">
            +
          </button>

          {/* Tercera fila: 1, 2, 3 | %, = */}
          <button className="btn btn-number" onClick={() => handleNumber('1')}>1</button>
          <button className="btn btn-number" onClick={() => handleNumber('2')}>2</button>
          <button className="btn btn-number" onClick={() => handleNumber('3')}>3</button>
          <button className="btn btn-operator" onClick={handlePercentage} aria-label="Porcentaje">
            %
          </button>
          <button className="btn btn-equals" onClick={handleEquals} aria-label="Igual">
            =
          </button>

          {/* Cuarta fila: 0, punto, paréntesis, retroceso */}
          <button className="btn btn-number btn-zero" onClick={() => handleNumber('0')}>0</button>
          <button className="btn btn-number" onClick={handleDecimal}>.</button>
          <button className="btn btn-operator" onClick={() => handleParenthesis('(')} aria-label="Abrir paréntesis">
            (
          </button>
          <button className="btn btn-operator" onClick={() => handleParenthesis(')')} aria-label="Cerrar paréntesis">
            )
          </button>
          <button 
            className="btn btn-control btn-delete" 
            onClick={handleDelete} 
            aria-label="Retroceder (Backspace)"
            title="Retroceder (Backspace)"
          >
            ⌫
          </button>

        </div>
      </div>
    </div>
  )
}

export default Calculator

