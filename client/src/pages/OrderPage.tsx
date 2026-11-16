import { useState, useEffect } from 'react';
import { Container, Typography, Box, Paper, Divider, Alert, CircularProgress } from '@mui/material';
import OrderForm from '../components/OrderForm';
import OrderStatusSelector from '../components/OrderStatusSelector';
import { useOrder } from '../hooks/useOrder';
import { Order, OrderStatus, CreateOrderDto } from '../types/order';

export function OrderPage() {
  const [selectedOrderId, setSelectedOrderId] = useState<string | null>(null);
  const [currentOrder, setCurrentOrder] = useState<Order | null>(null);
  const [notification, setNotification] = useState<{ type: 'success' | 'error'; message: string } | null>(null);
  
  const { 
    getOrderQuery,
    createOrderMutation,
    updateOrderMutation,
    deleteOrderMutation
  } = useOrder();

  const isPending = createOrderMutation.isPending || updateOrderMutation.isPending || deleteOrderMutation.isPending;
  const error = createOrderMutation.error || updateOrderMutation.error || deleteOrderMutation.error;

  useEffect(() => {
    if (selectedOrderId) {
      loadOrder(selectedOrderId);
    }
  }, [selectedOrderId]);

  const loadOrder = async (orderId: string) => {
    try {
      const queryResult = getOrderQuery(orderId);
      if (queryResult.data) {
        setCurrentOrder(queryResult.data);
      } else if (queryResult.error) {
        setNotification({ type: 'error', message: 'Error al cargar la orden' });
        setCurrentOrder(null);
      }
    } catch (err) {
      setNotification({ type: 'error', message: 'Error al cargar la orden' });
      setCurrentOrder(null);
    }
  };

  const handleCreateOrder = async (orderData: CreateOrderDto) => {
    try {
      const newOrder = await createOrderMutation.mutateAsync(orderData);
      setCurrentOrder(newOrder);
      setSelectedOrderId(newOrder.id);
      setNotification({ type: 'success', message: 'Orden creada exitosamente' });
    } catch (err) {
      setNotification({ type: 'error', message: 'Error al crear la orden' });
    }
  };

  const handleStatusChange = async (newStatus: OrderStatus) => {
    if (!currentOrder) return;
    
    try {
      const updatedOrder = await updateOrderMutation.mutateAsync({ 
        orderId: currentOrder.id, 
        updateData: { status: newStatus } 
      });
      setCurrentOrder(updatedOrder);
      setNotification({ type: 'success', message: 'Estado actualizado exitosamente' });
    } catch (err) {
      setNotification({ type: 'error', message: 'Error al actualizar el estado' });
    }
  };

  const handleDeleteOrder = async () => {
    if (!currentOrder) return;
    
    try {
      await deleteOrderMutation.mutateAsync(currentOrder.id);
      setCurrentOrder(null);
      setSelectedOrderId(null);
      setNotification({ type: 'success', message: 'Orden eliminada exitosamente' });
    } catch (err) {
      setNotification({ type: 'error', message: 'Error al eliminar la orden' });
    }
  };

  const handleOrderIdSubmit = (orderId: string) => {
    setSelectedOrderId(orderId.trim());
  };

  return (
    <Container maxWidth="md" sx={{ py: 4 }}>
      <Typography variant="h4" component="h1" gutterBottom sx={{ fontWeight: 'bold', mb: 3 }}>
        Gestión de Órdenes
      </Typography>

      {notification && (
        <Alert 
          severity={notification.type} 
          onClose={() => setNotification(null)}
          sx={{ mb: 3 }}
        >
          {notification.message}
        </Alert>
      )}

      <Box sx={{ display: 'flex', flexDirection: 'column', gap: 3 }}>
        <Paper elevation={2} sx={{ p: 3 }}>
          <Typography variant="h6" component="h2" gutterBottom>
            Crear Nueva Orden
          </Typography>
          <OrderForm 
            onSubmit={handleCreateOrder} 
            isPending={isPending} 
          />
        </Paper>

        <Divider />

        <Paper elevation={2} sx={{ p: 3 }}>
          <Typography variant="h6" component="h2" gutterBottom>
            Consultar Orden
          </Typography>
          <Box sx={{ display: 'flex', gap: 2, alignItems: 'center', mb: 2 }}>
            <input
              type="text"
              placeholder="Ingrese ID de orden"
              onKeyDown={(e) => {
                if (e.key === 'Enter') {
                  handleOrderIdSubmit((e.target as HTMLInputElement).value);
                }
              }}
              style={{
                padding: '10px',
                fontSize: '14px',
                borderRadius: '4px',
                border: '1px solid #ccc',
                flex: 1
              }}
            />
          </Box>

          {isPending && (
            <Box sx={{ display: 'flex', justifyContent: 'center', py: 4 }}>
              <CircularProgress />
            </Box>
          )}

          {currentOrder && !isPending && (
            <Box sx={{ mt: 2 }}>
              <Typography variant="subtitle1" sx={{ fontWeight: 'bold' }}>
                Orden: {currentOrder.id}
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Cliente: {currentOrder.customerId}
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Creada: {new Date(currentOrder.createdAt).toLocaleString()}
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Actualizada: {new Date(currentOrder.updatedAt).toLocaleString()}
              </Typography>

              <Box sx={{ mt: 2, mb: 2 }}>
                <Typography variant="subtitle2" gutterBottom>
                  Items:
                </Typography>
                {currentOrder.items.map((item, index) => (
                  <Box key={index} sx={{ ml: 2, mb: 1 }}>
                    <Typography variant="body2">
                      Producto: {item.productId} | Cantidad: {item.quantity} | Precio: ${item.price}
                    </Typography>
                  </Box>
                ))}
              </Box>

              <Divider sx={{ my: 2 }} />

              <Typography variant="subtitle2" gutterBottom>
                Cambiar Estado:
              </Typography>
              <OrderStatusSelector
                status={currentOrder.status}
                onStatusChange={handleStatusChange}
                disabled={isPending}
              />

              <Box sx={{ mt: 3, display: 'flex', gap: 2 }}>
                <button
                  onClick={handleDeleteOrder}
                  disabled={isPending}
                  style={{
                    padding: '10px 20px',
                    backgroundColor: '#d32f2f',
                    color: 'white',
                    border: 'none',
                    borderRadius: '4px',
                    cursor: isPending ? 'not-allowed' : 'pointer',
                    opacity: isPending ? 0.6 : 1
                  }}
                >
                  Eliminar Orden
                </button>
              </Box>
            </Box>
          )}

          {error && !isPending && (
            <Alert severity="error" sx={{ mt: 2 }}>
              {error.message}
            </Alert>
          )}
        </Paper>
      </Box>
    </Container>
  );
}