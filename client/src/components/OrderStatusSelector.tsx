import React from 'react';
import { FormControl, InputLabel, Select, MenuItem, SelectChangeEvent } from '@mui/material';
import { OrderStatus } from '../types/order';

interface OrderStatusSelectorProps {
  status: OrderStatus;
  onStatusChange: (status: OrderStatus) => void;
  disabled?: boolean;
}

const OrderStatusSelector: React.FC<OrderStatusSelectorProps> = ({
  status,
  onStatusChange,
  disabled = false,
}) => {
  const handleChange = (event: SelectChangeEvent<OrderStatus>) => {
    onStatusChange(event.target.value as OrderStatus);
  };

  return (
    <FormControl fullWidth disabled={disabled}>
      <InputLabel id="order-status-label">Estado</InputLabel>
      <Select
        labelId="order-status-label"
        value={status}
        label="Estado"
        onChange={handleChange}
      >
        <MenuItem value="PENDING">Pendiente</MenuItem>
        <MenuItem value="PROCESSING">En proceso</MenuItem>
        <MenuItem value="SHIPPED">Enviado</MenuItem>
        <MenuItem value="DELIVERED">Entregado</MenuItem>
        <MenuItem value="CANCELLED">Cancelado</MenuItem>
      </Select>
    </FormControl>
  );
};

export default OrderStatusSelector;