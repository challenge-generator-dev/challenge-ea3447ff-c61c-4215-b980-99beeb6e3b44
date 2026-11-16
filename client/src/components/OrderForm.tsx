import React, { useState } from 'react';
import { Button, TextField, Box, Typography, Paper } from '@mui/material';
import { CreateOrderDto, OrderItemDto } from '../types/order';

interface OrderFormProps {
  onSubmit: (orderData: CreateOrderDto) => void;
  isPending?: boolean;
}

const OrderForm: React.FC<OrderFormProps> = ({ onSubmit, isPending = false }) => {
  const [customerId, setCustomerId] = useState('');
  const [items, setItems] = useState<OrderItemDto[]>([{ productId: '', quantity: 1 }]);

  const handleItemChange = (index: number, field: keyof OrderItemDto, value: string | number) => {
    const newItems = [...items];
    newItems[index] = { ...newItems[index], [field]: value };
    setItems(newItems);
  };

  const addItem = () => {
    setItems([...items, { productId: '', quantity: 1 }]);
  };

  const removeItem = (index: number) => {
    if (items.length > 1) {
      const newItems = items.filter((_, i) => i !== index);
      setItems(newItems);
    }
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onSubmit({ customerId, items });
  };

  return (
    <Paper elevation={3} sx={{ padding: 3 }}>
      <Typography variant="h6" gutterBottom>
        Crear Nueva Orden
      </Typography>
      <Box component="form" onSubmit={handleSubmit} sx={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
        <TextField
          label="ID del Cliente"
          value={customerId}
          onChange={(e) => setCustomerId(e.target.value)}
          required
          fullWidth
        />

        <Typography variant="subtitle1">Items</Typography>
        {items.map((item, index) => (
          <Box key={index} sx={{ display: 'flex', gap: 2, alignItems: 'center' }}>
            <TextField
              label="ID del Producto"
              value={item.productId}
              onChange={(e) => handleItemChange(index, 'productId', e.target.value)}
              required
              sx={{ flex: 1 }}
            />
            <TextField
              label="Cantidad"
              type="number"
              value={item.quantity}
              onChange={(e) => handleItemChange(index, 'quantity', Number(e.target.value))}
              required
              inputProps={{ min: 1 }}
              sx={{ width: 100 }}
            />
            {items.length > 1 && (
              <Button
                variant="outlined"
                color="error"
                onClick={() => removeItem(index)}
                sx={{ height: '56px' }}
              >
                Eliminar
              </Button>
            )}
          </Box>
        ))}

        <Box sx={{ display: 'flex', gap: 2 }}>
          <Button
            variant="outlined"
            onClick={addItem}
            disabled={items.some(item => !item.productId)}
          >
            Añadir Item
          </Button>
          <Button
            type="submit"
            variant="contained"
            color="primary"
            disabled={isPending || !customerId || items.some(item => !item.productId)}
          >
            {isPending ? 'Creando...' : 'Crear Orden'}
          </Button>
        </Box>
      </Box>
    </Paper>
  );
};

export default OrderForm;