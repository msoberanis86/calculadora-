import React from 'react'
import '../styles/HistoryItem.css'

interface HistoryItemProps {
  id: string
  valor: number
  etiqueta: string
  onSelect: (id: string) => void
}

const HistoryItem: React.FC<HistoryItemProps> = ({ id, valor, etiqueta, onSelect }) => {
  return (
    <button
      className="history-item"
      onClick={() => onSelect(id)}
      aria-label={`Usar resultado: ${etiqueta}`}
    >
      <span className="history-label">{etiqueta}</span>
      <span className="history-value">{valor.toLocaleString('en-US')}</span>
    </button>
  )
}

export default HistoryItem

