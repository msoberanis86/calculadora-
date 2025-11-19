import { evaluate } from 'mathjs'

export function safeEvaluate(expression: string): number | null {
  try {
    // Limpiar la expresión de caracteres no permitidos, permitiendo paréntesis
    const cleaned = expression.replace(/[^0-9+\-*/().\s]/g, '')
    if (!cleaned.trim()) return null
    
    // Verificar que los paréntesis estén balanceados
    const openCount = (cleaned.match(/\(/g) || []).length
    const closeCount = (cleaned.match(/\)/g) || []).length
    if (openCount !== closeCount) {
      // Si no están balanceados, no evaluar aún
      return null
    }
    
    const result = evaluate(cleaned)
    return typeof result === 'number' && isFinite(result) ? result : null
  } catch (error) {
    return null
  }
}

export function formatNumber(num: number): string {
  // Formatear números para Guatemala: punto para decimales, coma para miles
  // Ejemplo: 1,234.56 (mil doscientos treinta y cuatro punto cincuenta y seis)
  
  if (num % 1 === 0) {
    // Números enteros: solo separador de miles con coma
    return num.toLocaleString('en-US')
  }
  
  // Para decimales, limitar a 10 decimales y eliminar ceros finales
  const rounded = Math.round(num * 10000000000) / 10000000000
  return rounded.toLocaleString('en-US', {
    maximumFractionDigits: 10,
    minimumFractionDigits: 0,
    useGrouping: true
  })
}

